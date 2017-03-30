# Encryption based on ROT-13

def rot13(string)
  list = ('a'..'z').to_a
  result = ''
  string.downcase.each_char do |char|
    if list.include?(char)
      idx = list.index(char)
      idx < 13 ? result += list[idx + 13] : result += list[idx - 13]
    else
      result += char
    end
  end

  result.split.map(&:capitalize).join(' ')
end

# Another solution from a Launchschool student
def decrypt(names)
  names.each { |name| puts name.tr('A-Za-z', 'N-ZA-Mn-za-m') }
end

# decrypt(ENCRYPTED_PIONEERS)

names = ['Nqn Ybirynpr',
'Tenpr Ubccre',
'Nqryr Tbyqfgvar',
'Nyna Ghevat',
'Puneyrf Onoontr',
'Noqhyynu Zhunzznq ova Zhfn ny-Xujnevmzv',
'Wbua Ngnanfbss',
'Ybvf Unyog',
'Pynhqr Funaaba',
'Fgrir Wbof',
'Ovyy Tngrf',
'Gvz Orearef-Yrr',
'Fgrir Jbmavnx',
'Xbaenq Mhfr',
'Wbua Ngnanfbss',
'Fve Nagbal Ubner',
'Zneiva Zvafxl',
'Lhxvuveb Zngfhzbgb',
'Unllvz Fybavzfxv',
'Tregehqr Oynapu']

# puts names.map { |name| rot13(name) }  # or,
print_names = method(:rot13).to_proc
puts names.map(&print_names)
