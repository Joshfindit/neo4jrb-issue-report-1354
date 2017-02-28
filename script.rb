gem 'neo4j-core', '=7.0.3'
gem 'neo4j', '=8.0.6'

require 'json'
require 'jsonapi-serializers'
require 'neo4j'
require 'neo4j/core/cypher_session/adaptors/http'
require 'neo4j/core/cypher_session/adaptors/bolt'
require 'securerandom' # UUID
require 'rexml/document'
require 'plist'
require 'digest'
require 'open3'
require 'tempfile'
require 'sinatra/base'


NEO4J_URL = "bolt://neo4j:password@localhost:7687"

class JunkNode
  include Neo4j::ActiveNode

  property :name, type: String
end

def get_session
  neo4j_adaptor = Neo4j::Core::CypherSession::Adaptors::Bolt.new(NEO4J_URL, {wrap_level: :proc})
  Neo4j::ActiveBase.on_establish_session { Neo4j::Core::CypherSession.new(neo4j_adaptor) }

  # Enable debugging Neo4j
  Neo4j::ActiveBase.current_session.adaptor.logger.level = Logger::DEBUG #DEBUG/ERROR/WARN
  Neo4j::Core::CypherSession::Adaptors::Base.subscribe_to_query(&method(:puts))
  Neo4j::Core::CypherSession::Adaptors::Bolt.subscribe_to_request(&method(:puts))
end



def import_filelist(filename)
    File.open(filename).each_with_index do |line, index|
      if thisJunkNode = JunkNode.find_by(name: line.strip)
      puts "Found node already"
    else
      puts "Does not exist. Creating."
      thisJunkNode = JunkNode.new(name: line.strip)
      thisJunkNode.save
    end
    JunkNode.all[0]
  end
end

get_session
Neo4j::ActiveBase.current_session.query("CREATE CONSTRAINT ON (n:JunkNode) ASSERT n.uuid IS UNIQUE") # Only needs to be run once, but no harm running it multiple times so not wrapping it in a check.

import_filelist("./filelist2.txt")
