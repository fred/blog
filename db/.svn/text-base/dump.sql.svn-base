-- MySQL dump 10.11
--
-- Host: localhost    Database: fred_blog
-- ------------------------------------------------------
-- Server version	5.0.51a-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `excerpt` text,
  `body` text,
  `published` tinyint(1) default '1',
  `user_id` int(11) default NULL,
  `permalink` varchar(40) default NULL,
  `published_date` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `formatting_type` varchar(20) default 'HTML',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_articles_on_permalink` (`permalink`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES (1,'Make your Rails app faster with memcached. Part 1','','h2. Make your Rails app faster with memcached. Part 1\r\n\r\nIn this article I describe how to make your application increase considerably in performance\r\n\r\nh2. Required Applications:\r\n\r\n* 1. cache_fu (plugin)\r\n\r\n./script/plugin discover\r\n./script/plugin install cache_fu\r\n\r\n* 2. memcache_client \r\n\r\ngem install memcache_client\r\n\r\n* 3. memcached \r\n\r\n(http://www.danga.com/memcached)\r\n<code>\r\nport install memcached\r\napt-get install memcached \r\nemerge memcached\r\nyum install memcached\r\n</code>\r\n\r\nor get the source and compile it.\r\n\r\nh2. Setup cache_fu\r\n\r\n* Run memcached\r\n* configure config/memcached.yml\r\n\r\n\r\nh2. Parts to cache in rails:\r\n\r\n1. Cache User Authentication\r\nrestfull_authentication:\r\nUser.current_user\r\nlogged_in?\r\n\r\n\r\nThose issue a DB query:\r\nSELECT * FROM users WHERE (users.`id` = 1) LIMIT 1\r\n\r\nedit user model (app/models/user.rb) \r\n<.>\r\nclass User < ActiveRecord::Base \r\n  acts_as_cached \r\n  after_save :expire_cache \r\nend\r\n</.>\r\n\r\n* note: only if you are not using cookie session store from rails2.0\r\n\r\nchange the method login_from_session in lib/authenticated_system.rb  \r\n\r\n# Called from #current_user. First attempt to login by the user id stored in the session. # Changed to read from Memcached \r\n\r\n[code lang=\"ruby\"]\r\n#\r\ndef login_from_session \r\n	#self.current_user = User.find_by_id(session[:user]) if session[:user] \r\n	self.current_user = User.get_cache(session[:user]) if session[:user] \r\nend \r\n[/code]\r\n\r\n\r\nSettings plugin\r\nI change the method self.object(var_name) in the file: vendor/plugins/settings/lib/settings.rb \r\n\r\n[code lang=\"ruby\"]\r\n#\r\nacts_as_cached \r\n\r\n#retrieve the actual Setting record \r\ndef self.object(var_name) \r\n	#Settings.find_by_var(var_name.to_s) \r\n	if Settings.cached?(var_name.to_s) \r\n		return Settings.get_cache(var_name.to_s) \r\n	else \r\n		setting = Settings.find_by_var(var_name.to_s)\r\n		Settings.set_cache(var_name.to_s,setting) \r\n	end\r\nend\r\n\r\n[/code]\r\n\r\nthen, I added a settings model: app/models/setting.rb\r\n\r\n[code lang=ruby]\r\n#\r\nclass Setting < ActiveRecord::Base \r\n	validates_uniqueness_of :var \r\n	acts_as_cached \r\n	after_save :expire_cache \r\n	after_save :expire_cached_var \r\n	\r\n	# Clear Cache by var \r\n	def expire_cached_var \r\n		Settings.all.each do |t| \r\n			Settings.clear_cache(t[0].to_s) \r\n		end\r\n	end\r\nend\r\n[/code]\r\n\r\n\r\n\r\nh2. Basic model caching\r\n\r\nAn example of article.rb\r\n\r\n<code>\r\nclass Article < ActiveRecord::Base \r\n  \r\n  validates_uniqueness_of :permalink\r\n  \r\n  def self.find_permalink(permalink) \r\n    if self.cached?(permalink) \r\n      return self.get_cache(permalink) \r\n    else \r\n      article = self.find_by_permalink(permalink) \r\n      self.set_cache(permalink,article) \r\n    end\r\n  end\r\nend\r\n</code>\r\n\r\n\r\n\r\nh2. THE BEST: partial caching:\r\n\r\nhere you can cache partials\r\nfor example in the view code:\r\n\r\n[code lang=\"ruby\"]\r\n\r\n#app/views/properties.html.erb\r\n\r\n  <% @articles.each do |article| %>  \r\n    <% cache article.permalink do %>  \r\n      <%= render :partial => \"each_article\", :locals => {:article => article} %> \r\n    <% end -%>\r\n  <% end -%>\r\n\r\n[/code]\r\n\r\n\r\nwill create $RAILS_ROOT/tmp/caches/properties/property_permalink.cache\r\nsomething like that, not sure what is the name\r\n\r\nTo sweep it after an update to the model:\r\n\r\nproperty.rb\r\n\r\n[code lang=\"ruby\"]\r\n \r\nclass Property < ActiveRecord::Base\r\n\r\n  acts_as_cached\r\n  after_save :reset_cache, :sweep_memcached\r\n  \r\n  def sweep_partial_cache\r\n    cache_dir = ActionController::Base.page_cache_directory+\"/..\"+\"/tmp/cache\"\r\n    unless cache_dir == RAILS_ROOT+\"/public\"\r\n      FileUtils.rm_r(Dir.glob(cache_dir+\"/\"+self.permalink.to_s+\".cache\")) rescue Errno::ENOENT\r\n      RAILS_DEFAULT_LOGGER.info(\"Cache directory \'#{cache_dir}\' fully sweeped.\")\r\n    end\r\n  end\r\n[/code]\r\n\r\n\r\n\r\n\r\nh2. auto_complete_for ajax using memcached\r\n\r\nproven to improve from 10 req/sec to 350 req/sec\r\n\r\ncomming soon... \r\nin part 2 of this article',1,1,'make-your-rails-app-faster-with-memcache','2007-12-13 00:00:00','2008-07-30 05:55:02','2008-08-09 09:31:05','Textile'),(2,'Very low memory VPS Linux for Rails','','The other day I had to set up a VPS machine at Slicehost for a client on a tight budget. I paid for 256mb VPS based on Gentoo, my distro of choice.\r\n<br />\r\n\r\nBut 256MB of ram? what can you do with just 256? \r\n<br />\r\n\r\nNormally a default 256mb linux machine would not handle very well a set of Apache + Mysql + 1 mongrel/thin/ebb instance. due to the high memory usage of a default configuration, it will swap very often.\r\n\r\n<br />\r\n\r\nAfter much research and instinct i made it run one thin servers with mysql and nginx, without any swapping, and really fast as it can be.\r\n\r\n<br />\r\n\r\nIf your linux start swapping often your performance will go down to the floor...  Swapping is bad, specially on a XEN VPS.\r\n\r\n<br />\r\n\r\nThe trick is to setup Mysql to use MYISAM and use Nginx instead of apache.\r\n\r\n<br />\r\n<br />\r\n\r\nHere is the process list with the Resident Memory usage, after 30 days uptime and about 1,800 page views on the website.\r\n\r\n<br />\r\n\r\n<br />\r\n\r\n<table>\r\n<tr>\r\n  <td> Mysqld 5.0.54 : </td> <td> 7.5 MB </td>\r\n</tr>\r\n<tr>\r\n  <td> Thin server each : </td> <td> 66.5 MB </td>\r\n</tr>\r\n<tr>\r\n   <td> Nginx 0.6.29 : </td> <td> 3.5 MB (1 worker)</td>\r\n</tr>\r\n<tr>\r\n  <td> Postfix </td> <td> 4.2 MB </td>\r\n</tr>\r\n</table>\r\n\r\nand others, such as sshd, cron, iptables, bash, together about 5mb.\r\n\r\n<br />\r\n<br />\r\n\r\nAs you can see, total of memory usage of the applications on the server is about 83 MB, thus leaving the server with 170MB of ram for the linux itself and file cache.\r\n\r\n<br />\r\n\r\nthis is what #free command tells:\r\n\r\n<br /> \r\n<pre>\r\n             total       used       free     shared    buffers     cached\r\nMem:           256        235         20          0         54         62\r\n-/+ buffers/cache:        128        128\r\nSwap:          511          0        511\r\n</pre>\r\n\r\n<br /> \r\n\r\nNice uh?\r\n\r\n<br /> \r\nyou can also make use of the nice tool called \"vmstat\"\r\n\r\n<br /> \r\nit\'s very import that \'si\' (swap in) and \'so\' (swap out) stays zero all the time.\r\n<br /> \r\ni.e. running vmstat 10 times with a 4 seconds interval. (ignore the 1st line)\r\n<pre>\r\n# vmstat 4 10\r\nprocs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----\r\n r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa\r\n 0  0    116  14900  56668  62692    1    1     3     3    9    5  0  0 100  0\r\n 0  0    116  14908  56668  62692    0    0     0     0   34   53  0  0 100  0\r\n 0  0    116  14968  56668  62692    0    0     0     0   37   54  0  0 100  0\r\n 0  0    116  14968  56668  62692    0    0     0     0   31   52  0  0 100  0\r\n....\r\n</pre>\r\n\r\n\r\n<br />\r\n<br />\r\n\r\n<h3>\r\nHere is the recipe:\r\n</h3>\r\n\r\n<h3> 1. Use MyIsam instead of InnoDB </h3>\r\nYou can read about it more in here: \r\n<a href=\"http://blog.evanweaver.com/articles/2007/04/30/top-secret-tuned-mysql-configurations-for-rails/\"> \r\nhttp://blog.evanweaver.com/articles/2007/04/30/top-secret-tuned-mysql-configurations-for-rails/\r\n</a>\r\n\r\n<br/ >\r\nI forgot to add that you need to dump your database first:\r\n<br />\r\nmysqldump -u root --all-databases > dump.sql\r\n<br />\r\nthen change my.cnf accordingly,\r\n<br />\r\nrestart mysql and reload the database\r\n<br />\r\nmysql -u root < dump.sql\r\n<br />\r\nChange only the values for my.cnf as shown below, and delete all innodb related stuff \r\n\r\n<pre>\r\n\r\n# can be safely set to 1M if you are really tight on Ram\r\nkey_buffer 			       = 4M\r\n\r\nmax_allowed_packet 			= 1M\r\ntable_cache 				= 32\r\nsort_buffer_size 			= 512k\r\nnet_buffer_length 			= 8K\r\nread_buffer_size 			= 512k\r\nread_rnd_buffer_size 		= 512K\r\n\r\n# can be safely set to 1M\r\nmyisam_sort_buffer_size 	= 2M  \r\n\r\nlanguage 					= /usr/share/mysql/english\r\n\r\n# security:\r\n# using \"localhost\" in connects uses sockets by default\r\n# skip-networking\r\nbind-address				= 127.0.0.1\r\n\r\n# No logging, \r\n# make sure you backup your database more often.\r\n#log-bin\r\n\r\nserver-id 					= 1\r\n\r\n# point the following paths to different dedicated disks\r\ntmpdir 						= /tmp/\r\n\r\n\r\n# Very important to have this here.\r\n# otherwise it will still load InnoDB.\r\nskip-innodb\r\n\r\n[mysqldump]\r\nquick\r\nmax_allowed_packet 			= 16M\r\n\r\n[mysql]\r\n# uncomment the next directive if you are not familiar with SQL\r\n#safe-updates\r\n\r\n[isamchk]\r\nkey_buffer 					= 8M\r\nsort_buffer_size 			= 8M\r\nread_buffer 				= 2M\r\nwrite_buffer 				= 2M\r\n\r\n[myisamchk]\r\nkey_buffer 					= 8M\r\nsort_buffer_size 			= 8M\r\nread_buffer 				= 2M\r\nwrite_buffer 				= 2M\r\n\r\n[mysqlhotcopy]\r\ninteractive-timeout\r\n\r\n</pre>\r\n\r\nIf you get problems reloading the database, stop mysql delete the contents in /var/lib/mysql/* , then run mysql-installdb and start it and reload again the sql dump file.\r\n\r\n<br />\r\nActually that\'s the way i most prefer..\r\n<br />\r\n<br />\r\n\r\n<h3> 2. Use nginx </h3> \r\n\r\n<p> this is an example nginx config file, located at /etc/nginx/nginx.conf </p>\r\n<pre>\r\nuser nginx nginx;\r\n# set to 2 or 3 if you have more processors or cores. \r\n# it will use about 3MB per worker\r\nworker_processes 1;\r\n\r\nerror_log /var/log/nginx/error_log info;\r\n\r\nevents {\r\n	# default is 8192\r\n	worker_connections  1024;\r\n	use epoll;\r\n}\r\n\r\nhttp {\r\n	include		/etc/nginx/mime.types;\r\n	default_type	application/octet-stream;\r\n\r\n	log_format main\r\n		\'$remote_addr - $remote_user [$time_local] \'\r\n       	\'\"$request\" $status $bytes_sent \'\r\n		\'\"$http_referer\" \"$http_user_agent\" \'\r\n		\'\"$gzip_ratio\"\';\r\n									       \r\n	client_header_timeout	10m;\r\n	client_body_timeout	10m;\r\n	send_timeout		10m;\r\n        client_body_buffer_size    128k;\r\n        proxy_buffer_size          4k;\r\n        proxy_buffers              4 32k;\r\n        proxy_busy_buffers_size    64k;\r\n        proxy_temp_file_write_size 64k;\r\n\r\n	connection_pool_size		256;\r\n	client_header_buffer_size	1k;\r\n	large_client_header_buffers	4 2k;\r\n	request_pool_size		4k;\r\n\r\n	gzip on;\r\n	gzip_http_version 1.1;\r\n        gzip_comp_level 6;\r\n        gzip_proxied any;\r\n        gzip_types text/plain text/html text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;\r\n        gzip_buffers 16 8k;\r\n        # Disable gzip for certain browsers.\r\n        gzip_disable \"MSIE [1-6]\\.(?!.*SV1)\";\r\n	gzip_min_length	1100;\r\n\r\n	output_buffers	1 32k;\r\n	postpone_output	1460;\r\n\r\n	sendfile	on;\r\n	tcp_nopush	on;\r\n	tcp_nodelay	on;\r\n\r\n	keepalive_timeout	75 20;\r\n\r\n	ignore_invalid_headers	on;\r\n\r\n	index index.html;\r\n    \r\n    # The following includes are specified for virtual hosts\r\n    include /var/www/apps/bla.com/shared/config/nginx.conf;\r\n\r\n}\r\n</pre>\r\n\r\n<p> this is an example vhost file </p>\r\n<pre>\r\nupstream mongrel_bla_com {\r\n  server 127.0.0.1:8001;\r\n}\r\n\r\nserver {\r\n	listen 80;\r\n	client_max_body_size 40M;\r\n	server_name bla.com www.bla.com;\r\n	root /var/www/apps/bla.com/current/public;\r\n	access_log  /var/www/apps/bla.com/shared/log/nginx.access.log;\r\n\r\n	location / {\r\n                proxy_set_header  X-Real-IP  $remote_addr;\r\n                proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;\r\n                proxy_set_header Host $http_host;\r\n                proxy_redirect false;\r\n                if (-f $request_filename/index.html) {\r\n                        rewrite (.*) $1/index.html break;\r\n                }\r\n                if (-f $request_filename.html) {\r\n                        rewrite (.*) $1.html break;\r\n                }\r\n                if (!-f $request_filename) {\r\n                        proxy_pass http://mongrel_bla_com;\r\n                        break;\r\n                }\r\n	}\r\n\r\n	location ~* ^.+\\.(jpg|js|jpeg|png|ico|gif|txt|js|css|swf|zip|rar|avi|exe|mpg|mp3|wav|mpeg|asf|wmv)$ {\r\n		root /var/www/apps/bla.com/current/public;\r\n	}\r\n\r\n}\r\n</pre>\r\n\r\n\r\n<h3> 3. Remove unnecessary Services you dont need.</h3>\r\n\r\n<br />\r\n\r\nSome linux distros have enabled by default services we dont need.\r\n<br />\r\nsuch as cupsd, apmd, acpid, mdns, samba, nfs, ftpd... etc...\r\n\r\n<br />\r\n<br />\r\n\r\n<h3> This is my make.conf in case it helps </h3>\r\n\r\n<br />\r\nNote that I set MAKEOPTS=\"-J1\" , it will only use 1 gcc process at the time, and not disturb the system, (machine has 4 cores)\r\n<br />\r\nAlso portage_niceness to 18, to make sure it will run smooth and not disturb thin and mysql.\r\n<br />\r\nfrom nice man page: \"Nicenesses range from -20 (most favorable scheduling) to 19 (least favorable).\"\r\n<br />\r\n\r\n\r\n<pre>\r\nCFLAGS=\"-march=athlon64 -O2\"\r\nCHOST=\"x86_64-pc-linux-gnu\"\r\nCXXFLAGS=\"${CFLAGS}\"\r\nMAKEOPTS=\"-j1\"\r\n\r\nUSE=\"3dnow 3dnowext apache2 \\\r\n     bash-completion bzip2 \\\r\n     -cups \\\r\n     gzip httpd hpn \\\r\n     innodb imagemagick \\\r\n     javascript jpeg \\\r\n     mmx mmxext mysql \\\r\n     nptl nptlonly \\\r\n     perl phyton png \\\r\n     ruby \\\r\n     screen sse sse2 sqlite sqlite3 ssl \\\r\n     threads udev unicode utf8 \\\r\n     vim-syntax \\\r\n     -X -kde -gnome -gtk -bindist \\\r\n     xml xml2 zlib \"\r\n\r\nGENTOO_MIRRORS=\"http://mirror.datapipe.net/gentoo http://gentoo.cites.uiuc.edu/pub/gentoo/ ftp://gentoo.mirrors.tds.net/gentoo http://ge\r\nAPACHE2_MPMS=\'worker\'\r\nPORTAGE_NICENESS=18\r\n</pre>\r\n\r\n<br />\r\nif you want to use mod_rails Passenger, set APACHE2_MPMS=\'prefork\'\r\n\r\n\r\n<br />\r\n<br />\r\nnote: I am positive you can throw in another thin server instance, and it will still not swap, or swap very little at all.\r\n\r\n<br />\r\n\r\n have fun \r\n\r\n<br /> \r\n<br /> \r\n**************************\r\n<br /> \r\n<h3> Updates : </h3>\r\n<br />\r\nWanna know what Slicehost Manager Diagnostics says about my VPS ?\r\n<pre>\r\nDiagnostics\r\n\r\n    * Your slice is currently running.\r\n    * The host server is up.\r\n    * Your swap IO usage over the last 4 hours is low: 0.0016 reads/s, 0.0 writes/s. (Read more about swap here)\r\n    * Your root IO usage over the last 4 hours is low: 0.038 reads/s, 0.1643 writes/s.\r\n    * The host server\'s load is nominal: 0.00, 0.03, 0.00.\r\n;)\r\n</pre>\r\n',1,1,'very-low-memory-vps-linux-for-rails','2008-07-03 00:00:00','2008-08-06 08:20:03','2008-08-06 09:33:33','HTML'),(4,'An Mplayer Config that plays 1080p','','<h2> This mplayer configuration file can play 1080p perfectly and smooth </h2>\r\n<p> it was tested on Athlon X2 4000, and Sempron CPU, and only 1GB Ram (Gentoo Linux) </p>\r\n\r\n<p> make sure you have your Video drivers configured and set\r\n<br />\r\nSuch as nvidia, ati(fglrx) and intel.\r\n<br />\r\nI think it should also work on any P4 or Athlon XP </p>\r\n\r\n<p> put this on ~/.mplayer/config <br /> \r\n(create it if it\'s not there)</p>\r\n\r\n\r\n<h2> ~/.mplayer/config </h2>\r\n\r\n<pre>\r\n\r\n# Write your default config options here!\r\n\r\n#======\r\n# Video\r\n#======\r\n\r\nvo=xv\r\n# Use double-buffering. (Recommended for xv with SUB/OSD usage)\r\ndouble=yes\r\n\r\n# Use 16MB of ram to cache the file\r\n# Increase to 64mb if you have spare Ram.\r\ncache=16380\r\n\r\nfs=yes\r\nni=yes\r\n\r\n# Video Output postprocessing quality \r\n# This sets the postprocessing into overdrive using all possible spare cpu cycles to make the movie look better\r\n# if  you have older CPU such as Athlon XP or Celeron, comment this.\r\n# Fast Machine: 90\r\n# Slow Machine: 10\r\nautoq=50\r\n\r\n# use this for widescreen monitor! non-square pixels\r\n# My monitor = 1440x900 == 16/10\r\n# Change this to your monitor.\r\nmonitoraspect=16:10\r\n\r\n\r\n\r\n#==========\r\n# Subtitles\r\n#==========\r\n\r\n\r\n# Align subs. (-1: as they want to align themselves)\r\nspualign=-1\r\n\r\n# Anti-alias subs. (4: best and slowest)\r\nspuaa=4\r\n# try 3 if your cpu is not so fast.\r\n# From mplayer man page:\r\n#                 0    none (fastest, very ugly)\r\n#                 1    approximate (broken?)\r\n#                 2    full (slow)\r\n#                 3    bilinear (default, fast and not too bad)\r\n#                 4    uses swscaler gaussian blur (looks very good)\r\n\r\n\r\n# Set language.\r\nslang=en,eng\r\n\r\n#===================\r\n# Text-based subtitles\r\n#===================\r\n\r\n# Find subtitle files. (1: load all subs containing movie name)\r\nsub-fuzziness=1\r\n\r\n# Set font encoding.\r\nsubfont-encoding=unicode\r\n\r\n# Set subtitle file encoding.\r\nunicode=yes\r\nutf8=yes\r\n\r\n# Resample the font alphamap. (1: narrow black outline)\r\nffactor=1\r\n\r\n# Set subtitle position. (100: as low as possible)\r\nsubpos=100\r\n\r\n# Set subtitle alignment at its position. (2: bottom)\r\nsubalign=2\r\n\r\n# Set font size. (2: proportional to movie width)\r\nsubfont-autoscale=2\r\n\r\n# Set font blur radius. (default: 2)\r\nsubfont-blur=2.0\r\n\r\n# Set font outline thickness. (default: 2)\r\nsubfont-outline=2.0\r\n\r\n# Set autoscale coefficient. (default: 5)\r\nsubfont-text-scale=4.4\r\n\r\n# OSD\r\n#====\r\n\r\n# Set autoscale coefficient. (default: 6)\r\nsubfont-osd-scale=4.4\r\n\r\n</pre>\r\n\r\n\r\n<p> Without this config the 1080p video plays terrible </p>\r\n\r\nNOTE: \r\n<br />\r\n1080p = 1920x1080 pixels\r\n',1,1,'an-mplayer-config-that-plays-1080p','2008-06-24 00:00:00','2008-08-06 09:34:25','2008-08-06 09:34:25','HTML'),(5,'Easy installing Passenger mod_rails on gentoo Linux','','<p>To install the great Mod_Rails on Gentoo linux it\'s as easy as 5 steps.</p>\r\n\r\n<p>Since you are Gentoo user, i don\'t need to go to details. You know what you doing. ;)</p>\r\n\r\n<h4>1. Recompile Apache non-threaded</h4>\r\n\r\nadd this to /etc/portage/package.use\r\n<pre>\r\nwww-servers/apache -threads\r\n</pre>\r\n\r\nand this to /etc/make.conf \r\n<pre>\r\nAPACHE2_MPMS=\"prefork\"\r\n</pre>\r\n\r\n<h4>2. Re emerge apache</h4>\r\n<pre>\r\n# emerge -va apache\r\n</pre>\r\n\r\n<h4>3. Passenger is in gentoo portage, but its in testing. Currently Version 2.0.1 </h4>\r\n<pre>\r\n# echo \"www-apache/passenger\" >> /etc/portage/package.keywords\r\n</pre>\r\n\r\n<h4>4. Install Passenger</h4>\r\n<pre> \r\n# emerge -va passenger\r\n</pre>\r\nIf it tries to install rails 2.0.2, rake, and lots of other gems that you already have installed trough rubygems, then run emerge with --nodeps option\r\n<pre>\r\n# emerge -va --nodeps passenger\r\n</pre>\r\n\r\n\r\n<h4>5. Edit /etc/conf.d/apache and add \"-D PASSENGER\" to apache options</h4>\r\nfor example mine looks like this:\r\n<pre>\r\nAPACHE2_OPTS=\"-D DEFAULT_VHOST -D INFO -D LANGUAGE -D PROXY -D PASSENGER\"\r\n</pre>\r\n\r\nThat\'s it. \r\n<br />\r\nNow just drop a similar vhost config file inside /etc/apache/vhosts.d/\r\n<br />\r\n\r\n<p>\r\nThis is a sample vhost file for a rails app.\r\n</p>\r\n\r\n<pre>\r\n&lt;VirtualHost *:80&gt;\r\n  ServerName mydomain.com\r\n  DocumentRoot /myapp/public\r\n  Include /etc/apache2/vhosts.d/deflate.conf\r\n  RailsBaseURI /\r\n  # The maximum number of Ruby on Rails application instances that may be simultaneously active. \r\n  # A larger number results in higher memory usage, but improved ability to handle concurrent HTTP clients. \r\n  # normally 1 to 10. (1 for each 50mb ram)\r\n  RailsMaxPoolSize 1\r\n  # The maximum number of seconds that a Ruby on Rails application instance may be idle.\r\n  # That is, if an application instance hasn\'t done anything after the given number of seconds,\r\n  # then it will be shutdown in order to conserve memory. ( 1 hour)\r\n  RailsPoolIdleTime 3600\r\n  RailsEnv \'production\'\r\n  &lt;Directory /myapp/public&gt;\r\n    Options FollowSymLinks\r\n    AllowOverride None\r\n    Order allow,deny\r\n    Allow from all\r\n    &lt;/Directory&gt;\r\n&lt;/VirtualHost&gt;\r\n</pre>\r\n\r\n\r\n\r\n\r\nMy sample deflate.conf, \r\nused to gzip the content \r\n\r\n<pre>\r\n&lt;Location /&gt;\r\n	SetOutputFilter DEFLATE\r\n	#\r\n	# Netscape 4.x has some problems...\r\n	BrowserMatch ^Mozilla/4 gzip-only-text/html\r\n	#\r\n	# Netscape 4.06-4.08 have some more problems\r\n	BrowserMatch ^Mozilla/4\\.0[678] no-gzip\r\n	#\r\n	# MSIE masquerades as Netscape, but it is fine\r\n	BrowserMatch \\bMSIE !no-gzip !gzip-only-text/html\r\n	# NOTE: Due to a bug in mod_setenvif up to Apache 2.0.48\r\n	# the above regex won\'t work. You can use the following\r\n	# workaround to get the desired effect:\r\n	BrowserMatch \\bMSI[E] !no-gzip !gzip-only-text/html\r\n	# Don\'t compress images\r\n	SetEnvIfNoCase Request_URI \\.(?:gif|jpe?g|png)$ no-gzip dont-vary\r\n	SetEnvIfNoCase Request_URI \\.(?:exe|t?gz|zip|bz2|sit|rar)$ no-gzip dont-vary\r\n	SetEnvIfNoCase Request_URI \\.pdf$ no-gzip dont-vary\r\n	# Make sure proxies don\'t deliver the wrong content\r\n	Header append Vary User-Agent env=!dont-vary\r\n&lt;/Location&gt;\r\n\r\nDeflateFilterNote Input instream\r\nDeflateFilterNote Output outstream\r\nDeflateFilterNote Ratio ratio\r\nLogFormat \'\"%r\" %{output_info}n/%{input_info}n (%{ratio_info}n%%)\' deflate\r\nCustomLog /var/log/apache2/deflate_log deflate\r\n\r\n</pre>\r\n\r\n\r\n<br />\r\n* Update on July 10, 2008.\r\n<br />\r\n- Now using gentoo portage to install it. it\'s more smooth.\r\n\r\n<br />\r\n\r\nNote:\r\n<br />\r\nPersonally I found that Thin + nginx uses less memory (Nginx 3MB, thin ~56MB)\r\napache + passenger will use quite more. (Apache 40MB, mod_rails ~50MB)\r\n',1,1,'easy-installing-passenger-mod_rails-on-g','2008-05-12 00:00:00','2008-08-06 09:35:19','2008-08-06 09:35:19','HTML'),(6,'Rails Session, be the fastest you can be. Libmemcached','','%p \r\n  To use The new Libmemcached and <a href=\"http://blog.evanweaver.com/files/doc/fauna/memcached\">memcached</a> by <a href=\"http://blog.evanweaver.com/\">Evan Weaver </a>, drop these lines on your config/environments/production.rb \r\n\r\nmemcached is up to 150x faster than memcache-client, and up to 15x faster than caffeine.\r\nSee <a href=\"http://blog.evanweaver.com/files/doc/fauna/memcached/files/BENCHMARKS.html\">BENCHMARKS</a> for details. \r\n\r\n\r\n%p \r\n  Also check out the Docs at :  \r\n  <a href=http://blog.evanweaver.com/files/doc/fauna/memcached>http://blog.evanweaver.com/files/doc/fauna/memcached</a>\r\n\r\n',1,1,'rails-session-be-the-fastest-you-can-be-','2008-08-06 00:00:00','2008-08-06 09:36:01','2008-08-09 10:04:56','HAML'),(9,'About Me','','%p\r\n  Im a ruby on Rails developer for about 3 years. \r\n  Ruby on Rails was my first web framework. I started from nothing with Ruby on Rails. I learned some about \'C for Unix\' and x86 Assembly at college, but that\'s it.\r\n\r\n\r\n%h3 Experience:\r\n\r\n%ul\r\n  %li I have experience with CSS and XHTML. My favorite is HAML and SASS.\r\n\r\n  %li Some experience with Mysql, Memecached, Sphinx, Ferret and merb.\r\n\r\n  %li Linux Administration and deployment.\r\n\r\n  %li Capistrano\r\n\r\n\r\n%h3 Conclusion:\r\n\r\n%p\r\n  My strong skills are mostly on Deployment with Capistrano, Ruby on Rails, Linux Administration and Linux for Rails deployment.\r\n  %br\r\n  *Gentoo Linux is my Favorite.\r\n\r\n\r\n%p \r\n  If you need to make sure your app is deployed correctly and running fast, let me know.',1,1,'about-me','2003-08-09 00:00:00','2008-08-09 09:01:51','2008-08-09 09:21:18','HAML'),(8,'Rails Playground Rocks','','I have been hosting many Rails applications in many different \"SHARED\" Hostings. \r\nand all I can say is that the best of them is Rails Playground...\r\n\r\n<h3> Here are my reasons: </h3>\r\n\r\n\r\n<h4> 1. Uptime is very good. </h4>\r\n\r\n 05:38:15 up 108 days,  9:56,  7 users,  load average: 0.46, 0.46, 0.45\r\n\r\n\r\n<h4> 2. Load is very Low </h4>\r\n\r\n Load average: 0.46, 0.46, 0.45\r\n\r\nfor 2 x dual core cpus, this load is Awesome.\r\nThe maximum load I have seen is like 1.9\r\n\r\n\r\n<h4> 3. Service is excellent </h4>\r\nEvery email I send I get the answer right back, with a good solution and help.\r\n\r\n\r\n<h4> 4. I asked for Git support </h4>\r\nand I got it, they installed git right away.\r\n\r\n\r\n<h4> 5. FAST Hardware </h4>\r\nin my rails application I get between 100 to 200 Req/sec using a single mongrel.\r\nI even get near results using FCGI !!!\r\nof course my app uses a LOT of caching, as well, using rails 2.0 edge from trunk.\r\nyou might not get same results...\r\n\r\n<h4> 6. Fast connection </h4>\r\nThey have resonably fast connections... \r\nFrom the the other side of the world (Japan, Thailand, Malaysia) I get real good speed.\r\n\r\n<h4> 7. Free 2 mongrel Instances </h4>\r\nI get 2 mongrel for the developer plan.\r\n\r\n\r\n<h4> 8. Free 1GB subversion repository </h4>\r\nif i had to pay for http://svnrepository.com/ it would cost another 5 USD month.\r\n\r\n\r\n<h4> 9. All newer gems </h4>\r\nOn my machine, 76 gems installed. well updated.\r\n\r\n\r\n\r\n<a href=\"http://svnrepository.com\"> SVNrepository.com</a> is a real good choice to pay if you need more space to host many applications and more support.\r\n\r\n\r\nSo, for for the newbie and junior Programmer, RailsPlayground is definitely worth it for the \"price\".\r\n\r\n\r\n<h3> Disclaimer : </h3>\r\n\r\nIT IS JUST MY PERSONAL OPINION, for a shared Hosting\r\nI don\'t guarantee you will get the same service as I get.\r\nyou might not get same results as I get...\r\nbasically, you might not be lucky as i am. :)\r\n\r\n\r\n<h3> NOTE: </h3>\r\n\r\nIf you have a critical application I do recommend to host on AMAZON EC2, \r\nor get your own Server Stack or Clusters.\r\n\r\n\r\n',1,1,'rails-playground-rocks','2007-12-31 00:00:00','2008-08-06 09:37:08','2008-08-06 09:37:08','HTML');
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(40) default NULL,
  `email` varchar(40) default NULL,
  `website` varchar(40) default NULL,
  `body` text,
  `approved` tinyint(1) default '0',
  `article_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,'Fred','fred','fred','memcached is up to 150x faster than memcache-client, and up to 15x faster than caffeine. See BENCHMARKS for details. READ the docs at :  http://blog.evanweaver.com/files/doc/fauna/memcached ',0,6,'2008-08-08 18:43:33','2008-08-08 18:43:33'),(2,'fred','fasfsadfwe','sdfasdgf','<pre> Pre Test </pre>\r\n\r\n<code> code test </code>\r\n\r\n<p> Hi P </p>',1,6,'2008-08-08 18:45:39','2008-08-08 19:02:26');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20080729010518'),('20080729011252'),('20080729030113'),('20080729030212'),('20080806075451'),('20080806081455'),('20080806085240'),('20080809090711');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL auto_increment,
  `var` varchar(255) NOT NULL,
  `value` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_settings_on_var` (`var`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL auto_increment,
  `tag_id` int(11) default NULL,
  `taggable_id` int(11) default NULL,
  `tagger_id` int(11) default NULL,
  `tagger_type` varchar(255) default NULL,
  `taggable_type` varchar(255) default NULL,
  `context` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
INSERT INTO `taggings` VALUES (1,1,1,NULL,NULL,'Article','tags','2008-08-06 08:54:10'),(2,2,1,NULL,NULL,'Article','tags','2008-08-06 08:54:10'),(3,3,1,NULL,NULL,'Article','tags','2008-08-06 08:54:10'),(4,4,1,NULL,NULL,'Article','tags','2008-08-06 08:54:10'),(5,5,1,NULL,NULL,'Article','tags','2008-08-06 08:54:10'),(6,6,2,NULL,NULL,'Article','tags','2008-08-06 09:12:39'),(7,7,2,NULL,NULL,'Article','tags','2008-08-06 09:12:39'),(8,8,2,NULL,NULL,'Article','tags','2008-08-06 09:12:40'),(9,9,2,NULL,NULL,'Article','tags','2008-08-06 09:12:40'),(10,10,2,NULL,NULL,'Article','tags','2008-08-06 09:12:40'),(12,7,4,NULL,NULL,'Article','tags','2008-08-06 09:34:25'),(13,12,4,NULL,NULL,'Article','tags','2008-08-06 09:34:25'),(14,13,5,NULL,NULL,'Article','tags','2008-08-06 09:35:19'),(15,14,5,NULL,NULL,'Article','tags','2008-08-06 09:35:19'),(16,6,5,NULL,NULL,'Article','tags','2008-08-06 09:35:19'),(17,7,5,NULL,NULL,'Article','tags','2008-08-06 09:35:19'),(18,3,6,NULL,NULL,'Article','tags','2008-08-06 09:36:01'),(19,5,6,NULL,NULL,'Article','tags','2008-08-06 09:36:01'),(20,15,6,NULL,NULL,'Article','tags','2008-08-06 09:36:01'),(21,16,8,NULL,NULL,'Article','tags','2008-08-06 09:37:08'),(22,5,8,NULL,NULL,'Article','tags','2008-08-06 09:37:08'),(23,17,9,NULL,NULL,'Article','tags','2008-08-09 09:01:51');
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'cache'),(2,'cache_fu'),(3,'memcached'),(4,'partial'),(5,'rails'),(6,'gentoo'),(7,'linux'),(8,'mysql'),(9,'nginx'),(10,'vps'),(11,'test'),(12,'mplayer'),(13,'apache'),(14,'mod_rails'),(15,'libmemcached'),(16,'shared hosting'),(17,'fred');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(40) default NULL,
  `name` varchar(100) default '',
  `email` varchar(100) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(40) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `last_name` varchar(40) default NULL,
  `time_zone` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_login` (`login`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','','fred@localhost.local','af70e6295a2524b11862af2a50ead0e33f542a8f',NULL,NULL,'2008-08-04 03:33:51',NULL,NULL,NULL,NULL),(2,'test123','','test@localhost','f455ea57f4e23180f95df34d1625f5e690f4b3d0','139be0fc064d1324f213aef0b44664ae2ce1260d','2008-07-29 02:16:47','2008-07-29 02:16:47',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2008-08-09 10:37:39
