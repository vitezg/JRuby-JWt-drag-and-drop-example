require "java"

import "eu.webtoolkit.jwt.WtServlet"

import "org.apache.catalina.startup.Tomcat"
import "org.apache.catalina.connector.Connector"

require "rubygems"
require "active_support"

$myconfig = ActiveSupport::JSON.decode(File.new(ARGV[ 0]).read)
File.open($myconfig["pidfile"], 'w') {|f| f.write(Process.pid.to_s+"\n")}

class MyServlet < WtServlet
  def createApplication(env)
    require $myconfig["servletfile"]
    Kernel.const_get($myconfig["servletclass"]).new(env)
  end
end

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

puts
puts
puts "touch "+$myconfig["stopfile"] + Process.pid.to_s
puts
puts
while ! File.exists?($myconfig["stopfile"] + Process.pid.to_s)
  sleep 1
end

begin
  tomcat.stop
  tomcat.destroy
rescue
rescue Exception
end
File.unlink($myconfig["pidfile"])
File.unlink($myconfig["stopfile"] + Process.pid.to_s)
puts
puts "Stopped."
puts
