module TagTreeMap
    TagTree.send("acts_as_treemap", :label => :node_label, :color => :node_color, :size => :node_size)

    def node_label
      if self.node_id
        obj = eval "#{self.klass}.find(#{self.node_id})"
        if obj && obj.respond_to?("label")
          return obj.label
        end
      end
      return self.name
    end

    def node_color
      if self.node_id
        obj = eval "#{self.klass}.find(#{self.node_id})"
        if obj && obj.respond_to?("color")
          return obj.color
        end
      end
      "000000"
    end

    def node_size
      if self.node_id
        obj = eval "#{self.klass}.find(#{self.node_id})"
        if !obj.nil? && obj.respond_to?("size")
          return obj.size
        end
      end
      return tree_map_calc_size(self)
    end

    def tree_map_calc_size(node)
      size = 1
      node.children.each do |child|
        size += tree_map_calc_size(child)
      end
      return size
    end

  end

