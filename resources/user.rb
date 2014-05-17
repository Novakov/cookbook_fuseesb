actions :create, :delete

attribute :name, :kind_of => String, :required => true, :name_attribute => true
attribute :password, :kind_of => String, :required => true
attribute :roles, :kind_of => Array, :default => []

def as_string
	s = "#{self.name}=#{self.password}"
	unless self.roles.empty? then
		s += ",#{self.roles.join(',')}"
	end

	s
end
