#the usual boilerplate
require 'java'

import "eu.webtoolkit.jwt.WContainerWidget"
import "eu.webtoolkit.jwt.WApplication"
import "eu.webtoolkit.jwt.WText"
import "eu.webtoolkit.jwt.WLength"
import "eu.webtoolkit.jwt.WImage"
import "eu.webtoolkit.jwt.WLink"
import "eu.webtoolkit.jwt.WFileResource"
import "eu.webtoolkit.jwt.WColor"
import "eu.webtoolkit.jwt.Orientation"

#the Character helper class is subclassed from the
#WContainerWidget we will have to override the dropEvent method
class Character < WContainerWidget
  def initialize(parent, color, name)
    super parent
    
    #we set a minimum size, and the background color
    setMinimumSize WLength.new("120px"),WLength.new("120px")
    getDecorationStyle.setBackgroundColor(WColor.new color)
    
    #add a WText to know who is who
    n = WText.new name, self
    n.setInline false
    @name = name
    
    #and add another WText for drag-and-drop messages
    @message = WText.new self
    @message.setInline false

  end
  
  #the dropEvenet implementation
  #this method is called when a drop event
  #happens
  def dropEvent(e)
    super
    
    #get the source widget for the drop event
    #this will be the pizza/chocolate/fish and chips
    #object
    w = e.getSource

    #move the food from the plate
    #to the character
    w.getParent.removeWidget w
    addWidget w

    #let's be nice and print a thank you message
    #the "mime type" represents the type of the
    #dropped object; it's set later in the code
    @message.setText "Thanks for the " + e.getMimeType

  end
end

#the application
class DragandDrop < WApplication
  def initialize(env)
    super
    setTitle("Drag And Drop")

    #create the plate
    @plate = WContainerWidget.new getRoot
    t = WText.new "Plate", @plate
    t.setInline false
    
    #now we create three images
    #first create a file resource, JWt
    #serves this on some private URL
    #then create a link to it, and finally the image 
    #which uses the link
    @pizza = WImage.new WLink.new(WFileResource.new("image/png","pizza.png")),"Pizza", @plate
    @chocolate = WImage.new WLink.new(WFileResource.new("image/png","chocolate.png")),"Chocolate", @plate
    @fc = WImage.new WLink.new(WFileResource.new("image/png","fishandchips.png")),"Fish and Chips", @plate

    #the duplicated images mentioned in the post
    dpizza = WImage.new WLink.new(WFileResource.new("image/png","pizza.png")),"Pizza", @plate
    dchocolate = WImage.new WLink.new(WFileResource.new("image/png","chocolate.png")),"Chocolate", @plate
    dfc = WImage.new WLink.new(WFileResource.new("image/png","fishandchips.png")),"Fish and Chips", @plate


    #now let's assign the types, and set
    #the images draggable
    #@pizza has the type "pizza"
    @pizza.setDraggable "pizza", dpizza, true
    @chocolate.setDraggable "chocolate", dchocolate, true
    @fc.setDraggable "fish and chips", dfc, true

    #and let's add the characters
    #@joe has a lightblue background,
    #is called Joe
    #and can only receive pizza and chocolate
    @joe = Character.new(getRoot, "lightblue","Joe")
    @joe.acceptDrops "pizza"
    @joe.acceptDrops "chocolate"

    #set up @jane too
    @jane = Character.new(getRoot, "pink","Jane")
    @jane.acceptDrops "fish and chips"
    @jane.acceptDrops "chocolate"

  end

end
