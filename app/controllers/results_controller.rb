class ResultsController < ApplicationController
  # 取り出す値の順位付け
  def priority(val)
    hash = { '(' => 5, '*' => 3, '×' => 3, '/' => 3, '÷' => 3,
             '+' => 2, '＋' => 2, '-' => 2, '−' => 2, ')' => 1, 'BTM' => 0 }

    rtn = hash[val]
    rtn ||= 4
  end

  def calc
    path = URI.unescape(request.fullpath.dup)
    str = query_params(path, request.path_info)
    return response_bad_request if str.blank?

    arr = str.scan(/\d+\.\d+|\d+|[^\s\w]/)
    stc = []                         # 逆ポーランド記法変換時の一時スタック
    rev_stc = []                     # 逆ポーランド記法の式を格納するスタック

    stc << 'BTM'                     # stackの底識別用

    # パラメータを逆ポーランド記法に変換しスタックに格納
    arr.each do |crt|
      crt_val = priority(crt)
      stc.size.times do |val|
        stc_val = priority(stc[stc.size - 1])
        if stc_val.to_i >= crt_val.to_i && stc[stc.size - 1] != '('
          rev_stc << stc.pop
        elsif crt_val.to_i > stc_val.to_i
          stc << crt
          break
        elsif stc_val.to_i == 5 && crt_val.to_i == 1
          stc.pop
          break
        else
          stc << crt
          break
        end
      end
    end

    # スタックに残った値を逆ポーランド記法のスタックに格納
    stc.size.times do |val|
      rev_stc <<  stc.pop
    end

    # 逆ポーランド記法の式を計算
    rev_stc.size.times do |val|
      i = rev_stc.shift
      case i
      when '+', '＋'
        stc << stc.pop.to_f + stc.pop.to_f
      when '-', '−'
        num1 = stc.pop.to_f
        num2 = stc.pop.to_f
        stc << num2 - num1
      when '*', '×'
        stc << stc.pop.to_f * stc.pop.to_f
      when '/', '÷'
        num1 = stc.pop.to_f
        num2 = stc.pop.to_f
        stc << num2 / num1
      when 'BTM'
        break
      else
        stc << i
      end
    end
    result = stc[0].truncate
    response_success(:result, :calc, result)
  end

  def grouping
    tmp = ''
    result = ''
    count = 1
    str = query_params(request.fullpath.dup, request.path_info)
    return response_bad_request if str.blank?

    str.each_char.with_index do |char, index|
      if tmp == char
        count += 1
      else
        if count > 1
          result += count.to_s
          count = 1
        end
        result += char
      end
      tmp = char
      result += count.to_s if str.length - 1 == index && count != 1
    end
    response_success(:result, :grouping, result)
  end

  def making_bignum
    str = query_params(request.fullpath.dup, request.path_info)
    return response_bad_request if str.blank?

    arr = str.split(',').sort!.reverse!
    arr.length.times do |i|
      (arr.length - (i + 1)).times do |j|
        next unless arr[j].to_i.digits.reverse[0] == arr[j + 1].to_i.digits.reverse[0]

        arr[j].to_i.digits.length.times do |k|
          if arr[j + 1].to_i.digits.reverse[k].nil?
            if arr[j].to_i.digits.reverse[k] < arr[j + 1].to_i.digits.reverse[arr[j + 1].to_i.digits.length - 1]
              arr[j], arr[j + 1] = arr[j + 1], arr[j]
              break
            end
          elsif arr[j].to_i.digits.reverse[k] < arr[j + 1].to_i.digits.reverse[k]
            arr[j], arr[j + 1] = arr[j + 1], arr[j]
            break
          end
        end
      end
    end
    result = arr.join
    response_success(:result, :making_bignum, result)
  end

  def most
    str = query_params(request.fullpath.dup, request.path_info)
    return response_bad_request if str.blank?

    hash = str.upcase.each_char.group_by(&:itself).transform_values(&:length)
    max_val = hash.values.max
    results = hash.select { |key, val| val == max_val }
    result = results.keys.join(',')
    response_success(:result, :most, result)
  end

  private

  def query_params(fullpath, path)
    fullpath.sub!(/#{path}\?/, '')
  end
end