# The program is used to guess equation for a desired result
# Support any length of operands, and any size of desired result
# 10000 Guesses time is below 1 second.
# Author:: Xingyu Ji

class EquationGuesser
  # constructor
  def initialize operands, desired_result
    @operands = operands
    @desired_result = desired_result.to_f
    @@operands_length = operands.length
    @result_map = {}
    @prune_flag_sum = false
    @prune_flag_multi = false
  end

  def guess guesses
    @guesses = guesses
    exact_answer = experiment("", 0, 0, @desired_result, @operands)
    if !exact_answer.nil?
      best_guess = print_guess(exact_answer, true)
    else
      best_guess = @result_map.min_by { |k, v| k.abs }[1]
    end
    puts "Guesses: #{guesses-@guesses} Best Guess: #{best_guess}"
  end

  # experiment
  # Params:: equation: current equation formed
  # multi_count, sum_count: count the appearance times of "+" or "*"
  # till the leaves of recursion, used to prune duplicated recursion branches
  # to reduces the average number of guesses.
  # target: desired result
  # operands: operands
  def experiment equation, multi_count, sum_count, target, operands
    # recursion exit condition
    if operands.size == 1
      if target.to_f == operands[0].to_f
        @guesses -= 1
        return operands[0].to_s
      else
        result_string = "#{operands[0]}#{equation}"
        @prune_flag_multi = true if equation.count("*") == @@operands_length - 1
        @prune_flag_sum = true if equation.count("+") == @@operands_length - 1
        print_guess(result_string, false)
        @guesses -= 1
        return nil
      end
    end

    operands.each_with_index do |operand, index|
      operators = operation_priority
      operators.each do |operator|
        if operator[1] == :*
          # if continue multiplication duplicated occur go to "next" loop
          next if @prune_flag_multi && multi_count == @@operands_length - 2
          multi_count += 1
        end
        if operator[1] == :+
          # if continue sum duplicated occur go to "next" loop
          next if @prune_flag_sum && sum_count == @@operands_length - 2
          sum_count += 1
        end
        mid_result = target.send(operator[0], operand.to_f)
        next if mid_result < 0
        sub_operands = operands.clone
        sub_operands.delete_at(index)
        final_result = experiment("#{equation} #{operator[1]} #{operand}", multi_count, sum_count, mid_result, sub_operands)
        # restore previous recursion counts
        multi_count -= 1 if operator[1] == :*
        sum_count -=1 if operator[1] == :+
        best_guess = "(#{final_result} #{operator[1]} #{operand})" unless final_result.nil?
        return best_guess unless final_result.nil?
        return if @guesses == 0
      end
    end
    nil
  end

  # Select operation sequence depend on the relative size of operands and desired result
  # In order to minimize the guess rounds
  def operation_priority
    @operands.max_by do |element|
      # if the biggest element in the operands can be divided by desired result
      # then no need to do "-" or "/" operations
      return [[:/, :*], [:-, :+]] if @desired_result / element > 1
      return [[:*, :/], [:+, :-], [:-, :+], [:/, :*]] if element / @desired_result > 1
    end
    @operands.min_by do |element|
      # if the smallest element of the operands could divide desired result
      # then do "/" or "-" first
      return [[:*, :/], [:+, :-], [:-, :+], [:/, :*]] if element / @desired_result > 1
    end
    [[:-, :+], [:+, :-], [:/, :*], [:*, :/]]
  end

  # print guess result
  def print_guess equation, exact_match
    if exact_match
      final_result = eval(equation)
      final_equation = equation + " = #{final_result} (#{final_result-@desired_result.to_i})"
      print_pattern = /(\)\s(?![\*\/])|([\/\*] \d+)\)\s(?=[\/\*]))/
      count = final_equation.scan(print_pattern).size
      final_equation = final_equation.gsub(print_pattern) do |x|
        x = "#{$2} "
      end
      final_equation = final_equation[count..-1]
    else
      final_equation = equation.gsub(/([\+,-] \d+ (?=[\*\/]))/) { |x| x="#{x}) " }
      final_equation.insert(0, '('*final_equation.count(')'))
      final_result = eval(final_equation)
      final_equation = "#{final_equation} = " + final_result.to_s + " (#{final_result-@desired_result.to_i})"
    end
    @result_map[final_result-@desired_result] = final_equation
    puts final_equation
    return final_equation
  end
end

start = Time.now.to_f.round(3)*1000
equation_guesser = EquationGuesser.new([1,1,2,3,4,1,3,123,32,2], 342)
equation_guesser.guess(10000)
endtime = Time.now.to_f.round(3)*1000
puts "Process finished, time consume: #{endtime-start}ms"