class Board < ActiveRecord::Base
  include ActionController::UrlWriter

  has_many :chats
  has_many :layers
  has_many :galleries
  has_many :publications
  before_create :create_layer

  validates_presence_of :title

  def create_layer
    l = Layer.new
    l.name = "Base Layer"
    layers << l
    return l
  end 

  def base_layer
    layers.first :order => "id ASC"
  end 

  def token
    return base_layer.token
  end

  def owner_link
    return polymorphic_path(self, :token => token)
  end

  def viewer_link
    return polymorphic_path(self)
  end

  def permission(token_param)
    if token_param == token
      return :owner
    elsif layer_from_token(token_param)	# return nil if it's viewer
      return :collaborator
    else
      return :viewer
    end
  end

  def layers_updated_after_revision(revision)
    self.layers.all :conditions => ['updated_at > ?', Time.at(revision).utc]
  end

  def chats_created_after_revision(revision)
    self.chats.all :conditions => ['created_at > ?', Time.at(revision).utc]
  end

  def latest_layers_table(layers, revision)
    table = {}
    layers.each {|layer| table[layer.id] = layer.prepare_table(revision)}
    return table
  end

  def latest_chats_table(chats)
    table = chats.map {|chat| {:author => chat.author, :body => chat.body}}
  end

  def table_of_updates_since_revision(revision)
    layers = self.layers_updated_after_revision(revision)
    chats = self.chats_created_after_revision(revision)
    latest = (layers.map {|l| l.updated_at} + chats.map {|c| c.created_at}).max.to_i || revision
    updates = {:revision => latest,
                :layers => latest_layers_table(layers, revision),
                :chats => latest_chats_table(chats)}
  end

  def layer_from_token(token_param)
    return layers.find_by_token(token_param)
  end


end
