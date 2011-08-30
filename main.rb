class Component
	attr_accessor :name, :pins

	def initialize(name, pins)
		@name = name
		@pins = {}

		pins.each do |p|
			@pins[p] = []
		end
	end

	def connect(pin, component, component_pin)
		if @pins.include?(pin)
			@pins[pin] << { :component => component, :pin => component_pin }
		else
			raise "Could not connect #{component.name} component to #{@name} because #{pin} pin does not exist"
		end
	end

	def emmit!(pin)
	end
end

class Source < Component
	def initialize(name)
		super(name, [ :neg, :pos ])
	end

	def emmit!(pin)
		res = []

		if (pin == :neg)
			res += @pins[:pos]
		end

		return res
	end
end

class A < Component
	def initialize(name)
		super(name, [ :a, :b, :c ])
	end

	def emmit!(pin)
		res = []

		if (pin == :c)
			res += @pins[:a]
			res += @pins[:b]
		end

		return res
	end
end

class B < Component
	def initialize(name)
		super(name, [ :d, :e ])
	end

	def emmit!(pin)
		res = []

		if (pin == :d)
			res += @pins[:e]
		end

		return res
	end
end

src = Source.new('src')
a1 = A.new('A1')
a2 = A.new('A2')
b1 = B.new('B1')

a2.connect(:b, src, :neg)
b1.connect(:e, a2, :a)
a1.connect(:a, a2, :c)
a1.connect(:b, b1, :d)
src.connect(:pos, a1, :c)

nodes = [ { :component => src, :pin => :neg } ]

while !nodes.empty? do
	n = nodes.shift

	puts "#{n[:component].name} emmitted from #{n[:pin]}!"
	nodes += n[:component].emmit!(n[:pin])

	break if nodes.include?( { :component => src, :pin => :neg } )
end
