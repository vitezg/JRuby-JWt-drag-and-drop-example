#the usual boilerplate
require "java"

import "eu.webtoolkit.jwt.WtServlet"

import "org.apache.catalina.startup.Tomcat"
import "org.apache.catalina.connector.Connector"

require "rubygems"
require "active_support"

#load the configuration
$myconfig = ActiveSupport::JSON.decode(File.new(ARGV[ 0]).read)
File.open($myconfig["pidfile"], 'w') {|f| f.write(Process.pid.to_s+"\n")}

#the servlet class, very simple
class MyServlet < WtServlet
  def createApplication(env)

    #load the "servletfile"
    require $myconfig["servletfile"]

    #return with a new instance of the "servletclass"
    Kernel.const_get($myconfig["servletclass"]).new(env)
  end
end

#set up and start Tomcat
tomcat = Tomcat.new
tomcat.setBaseDir("/tmp/")
con = Connector.new("org.apache.coyote.http11.Http11NioProtocol")
con.setPort($myconfig["port"])
tomcat.getService().addConnector(con)
tomcat.setConnector(con)
ctx = tomcat.addContext("", "/tmp/")
tomcat.addServlet("", "jwt example", MyServlet.new)
ctx.addServletMapping("/*", "jwt example")
ctx.addApplicationListener("eu.webtoolkit.jwt.ServletInit")
tomcat.start

#get a message out on how to stop the server
#simplest is to cut-and-paste the "touch .." command
#and run it
puts
puts
puts "touch "+$myconfig["stopfile"] + Process.pid.to_s
puts
puts

#wait for the stopfile to show up
while ! File.exists?($myconfig["stopfile"] + Process.pid.to_s)
  sleep 1
end

#stop Tomcat, catch any exceptions
begin
  tomcat.stop
  tomcat.destroy
rescue
rescue Exception
end

#clean up the pid and stop files
File.unlink($myconfig["pidfile"])
File.unlink($myconfig["stopfile"] + Process.pid.to_s)

puts
puts "Stopped."
puts
