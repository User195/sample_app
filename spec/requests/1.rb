person1 = {first: "First1", last: "Last1"}
person2 = {first: "First2", last: "Last2"}
person3 = {first: "First3", last: "Last3_child"}
params = {father: person1, mother: person2, child: person3}
puts person3[:first]
puts person2[:last]
puts params[:child][:last]
puts person1.merge(person3) { |key, oldval, newval| newval}