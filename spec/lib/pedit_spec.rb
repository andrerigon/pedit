require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'nokogiri'

describe "Pedit" do
  it "should parse ARGV[0] into a map" do
    dep = parse "org.test:test1:1.2"
    dep[:groupId].should be == "org.test"
    dep[:artifactId].should be == "test1"
    dep[:version].should be == "1.2"
  end
  
  it "should return dependencies from pom" do
    xml = "<project>
              <dependencies>
                  <dependency>
                      <groupId>test</groupId>
                      <artifactId>test1</artifactId>
                      <version>3.4</version>
                  </dependency>
              </dependencies>
              <build>
                  <plugins>
                  </plugins>
              </build>
          </project>"
          
    expected_deps = normalize "<dependencies>
                <dependency>
                    <groupId>test</groupId>
                    <artifactId>test1</artifactId>
                    <version>3.4</version>
                </dependency>
            </dependencies>"
            
    pom = parseXML xml    
    pom_deps = normalize (  (dependenciesFrom pom).to_xml )
    pom_deps.should be == expected_deps 
  end
  
  it "should add node" do
    xml = "<list>
          </list>"
    expected = normalize "<list><car>mercedes</car></list>"
    parent =  find_node parseXML(xml), 'list'
    
    newNode = simpleNode parent, :car, 'mercedes'
    addNodes parent, newNode
    
    normalize( parent.to_xml ) .should be == expected
  end
  
  def find_node(xml, selector)
    (  xml.css selector) [0]
  end
  
  def parseXML( xml )
    Nokogiri.XML xml
  end
  
  def normalize(str)
    str.gsub(/\n/,"").gsub(/\t/,"").gsub(/ /,"")
  end
end
