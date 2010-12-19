require 'nokogiri'

def add_dependency( dep ) 
  pom = pom_xml
  dependencies = dependenciesFrom pom
  addNodes dependencies, dependency( pom , dep ) 
  pom
end

def parse( arg )
  array = arg.split ':'
  { :groupId => array[0], :artifactId => array[1], :version => array[2] }
end 

def pom_xml
  Nokogiri.XML File.open 'pom.xml'
end

def dependenciesFrom( pom )
  pom.css("dependencies")[0]
end

def simpleNode(pom, name, value=''  )
  node = Nokogiri::XML::Node.new name.to_s, pom
  node.content = value
  node  
end

def addNodes( parent, *children )
  children.each { |c| parent.children.last.add_next_sibling c }
end

def dependency(pom, contents)
  artifactId = simpleNode pom, :artifactId, contents[:artifactId]
  groupId = simpleNode pom, :groupId, contents[:groupId]
  version = simpleNode pom, :version, contents[:version]
  dep = simpleNode pom, :dependency
  addNodes dep, artifactId, groupId, version
  dep 
end

def savePom( pom )
  file = File.open 'pom.xml', 'w+'
  file.write pom.to_xml
  file.close
end

def execute( args )
  savePom add_dependency( parse args[0] )
end

 