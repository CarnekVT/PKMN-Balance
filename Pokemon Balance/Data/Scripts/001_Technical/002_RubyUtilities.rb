#===============================================================================
# clase Object
#===============================================================================
class Object
  alias full_inspect inspect unless method_defined?(:full_inspect)

  def inspect
    return "#<#{self.class}>"
  end
end

#===============================================================================
# clase Class
#===============================================================================
class Class
  def to_sym
    return self.to_s.to_sym
  end
end

#===============================================================================
# clase String
#===============================================================================
class String
  def starts_with_vowel?
    return ["a", "e", "i", "o", "u"].include?(self[0].downcase)
  end

  def first(n = 1); return self[0...n]; end

  def last(n = 1); return self[-n..-1] || self; end

  def blank?; return self.strip.empty?; end

  def cut(bitmap, width)
    string = self
    width -= bitmap.text_size("...").width
    string_width = 0
    text = []
    string.scan(/./).each do |char|
      wdh = bitmap.text_size(char).width
      next if (wdh + string_width) > width
      string_width += wdh
      text.push(char)
    end
    text.push("...") if text.length < string.length
    new_string = ""
    text.each do |char|
      new_string += char
    end
    return new_string
  end

  def numeric?
    return !self[/\A[+-]?\d+(?:\.\d+)?\Z/].nil?
  end
end

#===============================================================================
# clase Numeric
#===============================================================================
class Numeric
  # Convierte un número en una cadena con formato 12.345.678.
  def to_s_formatted
    return self.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
  end

  def to_word
    ret = [_INTL("cero"), _INTL("uno"), _INTL("dos"), _INTL("tres"),
           _INTL("cuatro"), _INTL("cinco"), _INTL("seis"), _INTL("siete"),
           _INTL("ocho"), _INTL("nueve"), _INTL("diez"), _INTL("once"),
           _INTL("doce"), _INTL("trece"), _INTL("catorce"), _INTL("quince"),
           _INTL("dieciséis"), _INTL("diecisiete"), _INTL("dieciocho"), _INTL("diecinueve"),
           _INTL("veinte")]
    return ret[self] if self.is_a?(Integer) && self >= 0 && self <= ret.length
    return self.to_s
  end
end

#===============================================================================
# clase Array
#===============================================================================
class Array
  # xor de dos arrays
  def ^(other)
    return (self | other) - (self & other)
  end

  def swap(val1, val2)
    index1 = self.index(val1)
    index2 = self.index(val2)
    self[index1] = val2
    self[index2] = val1
  end
end

#===============================================================================
# clase Hash
#===============================================================================
class Hash
  def deep_merge(hash)
    merged_hash = self.clone
    merged_hash.deep_merge!(hash) if hash.is_a?(Hash)
    return merged_hash
  end

  def deep_merge!(hash)
    # failsafe
    return unless hash.is_a?(Hash)
    hash.each do |key, val|
      if self[key].is_a?(Hash)
        self[key].deep_merge!(val)
      else
        self[key] = val
      end
    end
  end
end

#===============================================================================
# module Enumerable
#===============================================================================
module Enumerable
  def transform
    ret = []
    self.each { |item| ret.push(yield(item)) }
    return ret
  end
end

#===============================================================================
# Collision testing
#===============================================================================
class Rect < Object
  def contains?(cx, cy)
    return cx >= self.x && cx < self.x + self.width &&
           cy >= self.y && cy < self.y + self.height
  end
end

#===============================================================================
# clase File
#===============================================================================
class File
  # Copia el archivo de origen a la ruta de destino.
  def self.copy(source, destination)
    data = ""
    t = System.uptime
    File.open(source, "rb") do |f|
      loop do
        r = f.read(4096)
        break if !r
        if System.uptime - t >= 5
          t += 5
          Graphics.update
        end
        data += r
      end
    end
    File.delete(destination) if File.file?(destination)
    f = File.new(destination, "wb")
    f.write data
    f.close
  end

  # Copia el origen al destino y elimina el origen.
  def self.move(source, destination)
    File.copy(source, destination)
    File.delete(source)
  end
end

#===============================================================================
# clase Color
#===============================================================================
class Color
  # alias del antiguo constructor
  alias init_original initialize unless self.private_method_defined?(:init_original)

  # Nuevo constructor, acepta valores RGB así como un número hexadecimal o valor de cadena.
  def initialize(*args)
    pbPrintException("¡Número de argumentos incorrectos! ¡Al menos se necesita 1!") if args.length < 1
    case args.length
    when 1
      case args.first
      when Integer
        hex = args.first.to_s(16)
      when String
        try_rgb_format = args.first.split(",")
        init_original(*try_rgb_format.map(&:to_i)) if try_rgb_format.length.between?(3, 4)
        hex = args.first.delete("#")
      end
      pbPrintException("¡Tipo de argumento incorrecto!") if !hex
      r = hex[0...2].to_i(16)
      g = hex[2...4].to_i(16)
      b = hex[4...6].to_i(16)
    when 3
      r, g, b = *args
    end
    init_original(r, g, b) if r && g && b
    init_original(*args)
  end

  def self.new_from_rgb(param)
    return Font.default_color if !param
    base_int = param.to_i(16)
    case param.length
    when 8   # 32-bit hex
      return Color.new(
        (base_int >> 24) & 0xFF,
        (base_int >> 16) & 0xFF,
        (base_int >> 8) & 0xFF,
        (base_int) & 0xFF
      )
    when 6   # 24-bit hex
      return Color.new(
        (base_int >> 16) & 0xFF,
        (base_int >> 8) & 0xFF,
        (base_int) & 0xFF
      )
    when 4   # 15-bit hex
      return Color.new(
        ((base_int) & 0x1F) << 3,
        ((base_int >> 5) & 0x1F) << 3,
        ((base_int >> 10) & 0x1F) << 3
      )
    when 1, 2   # Color number
      case base_int
      when 0 then return Color.white
      when 1 then return Color.blue
      when 2 then return Color.red
      when 3 then return Color.green
      when 4 then return Color.cyan
      when 5 then return Color.pink
      when 6 then return Color.yellow
      when 7 then return Color.gray
      else        return Font.default_color
      end
    end
    return Font.default_color
  end

  # @return [String] la representación de 15 bits de este color en una cadena, ignorando su alfa
  def to_rgb15
    ret = (self.red.to_i >> 3)
    ret |= ((self.green.to_i >> 3) << 5)
    ret |= ((self.blue.to_i >> 3) << 10)
    return sprintf("%04X", ret)
  end

  # @return [String] este color en el formato "RRGGBB", ignorando su alfa
  def to_rgb24
    return sprintf("%02X%02X%02X", self.red.to_i, self.green.to_i, self.blue.to_i)
  end

  # @return [String] este color en el formato "RRGGBBAA" (o "RRGGBB" si el alfa de este color es 255)
  def to_rgb32(always_include_alpha = false)
    if self.alpha.to_i == 255 && !always_include_alpha
      return sprintf("%02X%02X%02X", self.red.to_i, self.green.to_i, self.blue.to_i)
    end
    return sprintf("%02X%02X%02X%02X", self.red.to_i, self.green.to_i, self.blue.to_i, self.alpha.to_i)
  end

  # @return [String] este color en el formato "#RRGGBB", ignorando su alfa
  def to_hex
    return "#" + to_rgb24
  end

  # @return [Integer] este color en formato RGB convertido a un número entero
  def to_i
    return self.to_rgb24.to_i(16)
  end

  # @return [Color] el color que contrasta con este
  def get_contrast_color
    r = self.red
    g = self.green
    b = self.blue
    yuv = [
      (r * 0.299) + (g * 0.587) + (b * 0.114),
      (r * -0.1687) + (g * -0.3313) + (b *  0.500) + 0.5,
      (r * 0.500) + (g * -0.4187) + (b * -0.0813) + 0.5
    ]
    if yuv[0] < 127.5
      yuv[0] += (255 - yuv[0]) / 2
    else
      yuv[0] = yuv[0] / 2
    end
    return Color.new(
      yuv[0] + (1.4075 * (yuv[2] - 0.5)),
      yuv[0] - (0.3455 * (yuv[1] - 0.5)) - (0.7169 * (yuv[2] - 0.5)),
      yuv[0] + (1.7790 * (yuv[1] - 0.5)),
      self.alpha
    )
  end

  # Convierte la cadena hexadecimal/entero de 24 bits proporcionada en valores RGB.
  def self.hex_to_rgb(hex)
    hex = hex.delete("#") if hex.is_a?(String)
    hex = hex.to_s(16) if hex.is_a?(Numeric)
    r = hex[0...2].to_i(16)
    g = hex[2...4].to_i(16)
    b = hex[4...6].to_i(16)
    return r, g, b
  end

  # Analiza la entrada como un Color y devuelve un objeto Color creado a partir de ella.
  def self.parse(color)
    case color
    when Color
      return color
    when String, Numeric
      return Color.new(color)
    end
    # Devuelve nil si la entrada es incorrecta
    return nil
  end

  # Devuelve un objeto de color para algunos colores comúnmente utilizados.
  def self.red;     return Color.new(255, 128, 128); end
  def self.green;   return Color.new(128, 255, 128); end
  def self.blue;    return Color.new(128, 128, 255); end
  def self.yellow;  return Color.new(255, 255, 128); end
  def self.magenta; return Color.new(255,   0, 255); end
  def self.cyan;    return Color.new(128, 255, 255); end
  def self.white;   return Color.new(255, 255, 255); end
  def self.gray;    return Color.new(192, 192, 192); end
  def self.black;   return Color.new(  0,   0,   0); end
  def self.pink;    return Color.new(255, 128, 255); end
  def self.orange;  return Color.new(255, 155,   0); end
  def self.purple;  return Color.new(155,   0, 255); end
  def self.brown;   return Color.new(112,  72,  32); end
end

#===============================================================================
# Envuelve bloques de código en una clase que pasa datos accesibles como variables de instancia
# dentro del bloque de código.
#
# wrapper = CallbackWrapper.new { puts @test }
# wrapper.set(test: "Hola")
# wrapper.execute  #=>  "Hola"
#===============================================================================
class CallbackWrapper
  @params = {}

  def initialize(&block)
    @code_block = block
  end

  def execute(given_block = nil, *args)
    execute_block = given_block || @code_block
    @params.each do |key, value|
      args.instance_variable_set("@#{key}", value)
    end
    args.instance_eval(&execute_block)
  end

  def set(params = {})
    @params = params
  end
end

#===============================================================================
# Métodos de Kernel
#===============================================================================
def rand(*args)
  Kernel.rand(*args)
end

class << Kernel
  alias oldRand rand unless method_defined?(:oldRand)
  def rand(a = nil, b = nil)
    if a.is_a?(Range)
      lo = a.min
      hi = a.max
      return lo + oldRand(hi - lo + 1)
    elsif a.is_a?(Numeric)
      if b.is_a?(Numeric)
        return a + oldRand(b - a + 1)
      else
        return oldRand(a)
      end
    elsif a.nil?
      return oldRand(b)
    end
    return oldRand
  end
end

def nil_or_empty?(string)
  return string.nil? || !string.is_a?(String) || string.size == 0
end

#===============================================================================
# Interpolación lineal entre dos valores, dada la duración del cambio y
# ya sea:
#   - el tiempo transcurrido desde el inicio del cambio (delta), o
#   - el tiempo de inicio del cambio (delta) y el tiempo actual (now)
#===============================================================================
def lerp(start_val, end_val, duration, delta, now = nil)
  return end_val if duration <= 0
  delta = now - delta if now
  return start_val if delta <= 0
  return end_val if delta >= duration
  return start_val + ((end_val - start_val) * delta / duration.to_f)
end
