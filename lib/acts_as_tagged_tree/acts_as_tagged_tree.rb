# ActsAsTaggedTree
module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Tagged #:nodoc:
      module Tree #:nodoc:
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods

          def acts_as_tagged_tree(options = { })
            configuration = { :label => "name", :treemap => false}
            configuration.update(options) if options.is_a?(Hash)
            if configuration[:treemap]
              TagTree.send("include",TagTreeMap)
#              TagTree.class_eval("require 'tag_tree_map';include TagTreeMap")
            end
            self.class_eval <<-EOF
def _tagged_tree_label
  "#{configuration[:label]}"
end
EOF
            after_save :tagged_tree_update_node
            before_destroy :tagged_tree_destroy_node
            include ActiveRecord::Acts::Tagged::Tree::InstanceMethods
          end
        end

        module InstanceMethods
          def tagged_tree_update_node
            begin
              TagTree.delete(:conditions => { :node_id => self.id})
            end
            self.tag_list.each do |t|
              tag = Tag.find_by_name(t)
              tag_node = TagTree.find_by_tag_id(tag.id) || TagTree.create(:parent_id => 1, :tag_id => tag.id, :name => tag.name)
              TagTree.create(:parent_id => tag_node.id, :tag_id => tag.id, :name => self.send(_tagged_tree_label), :node_id => self.id, :klass => self.class.to_s) unless TagTree.find(:first,:conditions => ["tag_id = ? and node_id = ?", tag.id, self.id])
            end
          end

          def tagged_tree_destroy_node
            begin
              TagTree.delete(:conditions => { :node_id => self.id})
            end
            true
          end
        end
      end
    end
  end
end


ActiveRecord::Base.send(:include, ActiveRecord::Acts::Tagged::Tree)
