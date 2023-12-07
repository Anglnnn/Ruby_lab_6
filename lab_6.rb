require 'json'

class Passenger
  attr_accessor :num_of_items, :total_weight, :name

  def initialize(name, num_of_items, total_weight)
    @name = name
    @num_of_items = num_of_items
    @total_weight = total_weight
  end

  # Обчислення середньої маси речей для пасажира
  def average_item_weight
    @total_weight / @num_of_items.to_f
  end

  # Перетворення об'єкту пасажира в JSON
  def to_json
    { name: @name, num_of_items: @num_of_items, total_weight: @total_weight }.to_json
  end

  # Створення об'єкту пасажира з JSON-рядка
  def self.from_json(json)
    data = JSON.parse(json)
    new(data['name'], data['num_of_items'], data['total_weight'])
  end
end

class PassengerAnalyzer
  def initialize(passengers)
    @passengers = passengers
  end

  # Додавання нового пасажира
  def add_passenger(passenger)
    @passengers << passenger
  end

  # Видалення пасажира
  def remove_passenger(passenger)
    @passengers.delete(passenger)
  end

  # Виведення статистики
  def display_statistics
    puts "Загальна кількість пасажирів: #{passenger_count}"
    puts "Загальна середня маса речей: #{average_item_weight_all} кг"
    puts "Найлегший пасажир: #{lightest_passenger.name}"
    puts "Найважчий пасажир: #{heaviest_passenger.name}"
  end

  # Кількість пасажирів із більше ніж двома речима
  def more_than_two_items_count
    @passengers.count { |passenger| passenger.num_of_items > 2 }
  end

  # Кількість пасажирів із кількістю речей більше за середню
  def exceed_average_items_count
    overall_average = average_item_weight_all
    @passengers.count { |passenger| passenger.num_of_items > overall_average }
  end

  # Збереження даних у файл
  def save_to_file(filename)
    File.write(filename, @passengers.map(&:to_json).join("\n"))
  end

  # Завантаження даних з файлу
  def load_from_file(filename)
    data = File.read(filename).split("\n")
    @passengers = data.map { |json| Passenger.from_json(json) }
  end

  private

  # Загальна кількість пасажирів
  def passenger_count
    @passengers.size
  end

  # Середня маса речей для всіх пасажирів
  def average_item_weight_all
    total_weight = @passengers.map(&:total_weight).sum
    total_items = @passengers.map(&:num_of_items).sum
    total_weight / total_items.to_f
  end

  # Знайти найлегшого пасажира
  def lightest_passenger
    @passengers.min_by(&:total_weight)
  end

  # Знайти найважчого пасажира
  def heaviest_passenger
    @passengers.max_by(&:total_weight)
  end
end

# Приклад використання:
passenger1 = Passenger.new('John', 3, 15)
passenger2 = Passenger.new('Alice', 2, 20)

analyzer = PassengerAnalyzer.new([passenger1, passenger2])

# Додавання нового пасажира
passenger3 = Passenger.new('Bob', 4, 30)
analyzer.add_passenger(passenger3)

# Видалення пасажира
analyzer.remove_passenger(passenger1)

# Збереження та завантаження даних
analyzer.save_to_file('passengers_data.json')
analyzer.load_from_file('passengers_data.json')

# Виведення статистики
analyzer.display_statistics
