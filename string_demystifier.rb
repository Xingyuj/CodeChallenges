# Pass a string to demystify
# pass riddle string to constructor, then call demystify to get plain text
# func demystify return a plain text string
#
# Author:: Xingyu Ji
#

class StringDemystifier

  def initialize riddle
    @riddle = riddle
    @first_process = /(\w)\w\1/
    @second_process = /(\w)\1{5}/
  end

  def demystify
    if !(@first_process =~ @riddle) && !(@second_process =~ @riddle) && !@riddle.include?("!")
      return @riddle
    end
    # first process transfer "AWA" -> "AAA"
    @riddle = @riddle.gsub(@first_process) do |result|
      result = "#{$1}"*result.length
    end
    # second process transfer "AAAAAA" -> "A"
    @riddle = @riddle.gsub(@second_process) do |result|
      result = "#{$1}"
    end
    # third process only reverse the string once when the string contains odd "!"
    @riddle = @riddle.count("!") % 2 == 1 ? @riddle.reverse.delete("!") : @riddle.delete("!")
    # recursion until all processes can't be applied
    demystify
  end

end

string_demystifier = StringDemystifier.new "!YTIRCO!IQIIQIDEMGMMIM FO YMJMMSM!RA !EGEEJEHT ROEOOSOF PAEJEEBEL TN!AIKIITIG ENVNNMNO ,GQGGCGN!ILEKIZIISIRT RJRRDROF PETOTTJTS LLZLLEL!AMSXSSMS ENODOOSO"
puts string_demystifier.demystify
