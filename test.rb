require 'rails'
require 'byebug'
# Variáveis globais
dict = {}
words = []

file_set = ARGV[0]
not_considered_words = ARGV[1]
query_file = ARGV[2]

consulta_file = File.open(query_file, 'r')

files_path = File.open(file_set, 'r').readlines.map(&:chomp)
to_not_consider = File.open(not_considered_words, 'r').readlines.map(&:chomp)
query = File.open(query_file, 'r').read

files_path.each do |file_path|
  File.open(file_path, 'r') do |file|
    words.append(file.read.split(' '))
  end
end

def remove_characters_and_pontuation(words)
  return words.map { |inner_words| inner_words.map {|word| word.gsub(/[^a-zA-Z0-9\s]/, '')}  }
end

words = remove_characters_and_pontuation(words)

def remove_not_considered_words(arqseries, to_not_consider)
  arqseries.each_with_index do |value, index|
    if to_not_consider.include?(value)
      arqseries.delete_at(index)
    end
  end
end

def create_index(words, dict, to_not_consider)
  words.each_with_index do |i, narq|
    i = i.to_a
    remove_not_considered_words(i, to_not_consider)
    list = []
    i.group_by(&:itself).each do |key, value|
      list.append([key, narq + 1, value.length])
    end

    list.each do |v|
      if dict.key?(v[0])
        dict[v[0]].append([v[1], v[2]])
      else
        dict[v[0]] = [[v[1], v[2]]]
      end
    end
  end

  # Organiza o dicionario que representa o indice em ordem alfabetica
  sorted_items = dicionario.sort_by { |k, _| k }
  # Cria o arquivo de indice
  File.open('indice.txt', 'w') do |index|
    sorted_items.each do |line|
      index.write("#{line[0]}: ")
      line[1].each do |value|
        index.write("#{value[0]},#{value[1]} ")
      end
      index.write("\n")
    end
    puts 'Arquivo de indice criado'
  end
end

#  do |files_words.map do |words| word.gsub(/[^a-zA-Z0-9\s]/, '') | 
