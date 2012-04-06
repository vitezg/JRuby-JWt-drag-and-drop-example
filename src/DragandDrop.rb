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

class Character < WContainerWidget
  def initialize(parent, color, name)
    super parent
    setMinimumSize WLength.new("120px"),WLength.new("120px")
    getDecorationStyle.setBackgroundColor(WColor.new color)
    n = WText.new name, self
    n.setInline false
    @name = name
    @message = WText.new self
    @message.setInline false
  end
  def dropEvent(e)
    puts @name + ": got dropevent: " + e.getMimeType
    w = e.getSource
    w.getParent.removeWidget w
    addWidget w
    @message.setText "Thanks for the " + e.getMimeType
  end
end

class DragandDrop < WApplication
  def initialize(env)
    super
    setTitle("Drag And Drop")

    @plate = WContainerWidget.new getRoot

    @pizza = WImage.new WLink.new(WFileResource.new("image/png","pizza.png")),"Pizza", @plate
    @chocolate = WImage.new WLink.new(WFileResource.new("image/png","chocolate.png")),"Chocolate", @plate
    @fc = WImage.new WLink.new(WFileResource.new("image/png","fishandchips.png")),"Fish and Chips", @plate

    dpizza = WImage.new WLink.new(WFileResource.new("image/png","pizza.png")),"Pizza", @plate
    dchocolate = WImage.new WLink.new(WFileResource.new("image/png","chocolate.png")),"Chocolate", @plate
    dfc = WImage.new WLink.new(WFileResource.new("image/png","fishandchips.png")),"Fish and Chips", @plate



    @pizza.setDraggable "pizza", dpizza, true
    @chocolate.setDraggable "chocolate", dchocolate, true
    @fc.setDraggable "fish and chips", dfc, true

    @joe = Character.new(getRoot, "lightblue","Joe")
    @joe.acceptDrops "pizza"
    @joe.acceptDrops "chocolate"

    @jane = Character.new(getRoot, "pink","Jane")
    @jane.acceptDrops "fish and chips"
    @jane.acceptDrops "chocolate"

  end

end
