Tinify = require './Tinify'

module.exports =
class GBDumper
  data: []
  i: 0x0150

  loadBuffer: (buffer) ->
    @data.push.apply(@data, buffer)

  le2: (b0, b1) -> (b1 << 8) + b0
  le4: (b0, b1, b2, b3) -> (b3 << 24) + (b2 << 16) + (b1 << 8) + b0

  read16: (tinify) ->
    r = @le2(@data[@i], @data[@i+1])
    @i += 2
    if tinify == false
      return r
    Tinify.hex(r, 4)

  read8: (tinify) ->
    r = @data[@i]
    @i++
    if tinify == false
      return r
    Tinify.hex(r, 2)

  process: ->
    b0 = b1 = null
    instr = null
    ret = ""
    while @i < @data.length / 200
      b0 = @read8(false)
      switch b0
        when 0x00 then instr = ['nop']
        when 0x01 then instr = ['ld', 'reg:bc', "imm16:#{@read16()}"]
        when 0x02 then instr = ['ld', 'indreg:(bc)', 'reg:a']
        when 0x03 then instr = ['inc', 'reg:bc']
        when 0x04 then instr = ['inc', 'reg:b']
        when 0x05 then instr = ['dec', 'reg:b']
        when 0x06 then instr = ['ld', 'reg:b', "imm8:#{@read8()}"]
        when 0x07 then instr = ['rlca']
        when 0x08 then instr = ['ld', "ind16:(#{@read16()})", 'reg:sp']
        when 0x09 then instr = ['add', 'reg:hl', 'reg:bc']
        when 0x0A then instr = ['ld', 'reg:a', 'indreg:(bc)']
        when 0x0B then instr = ['dec', 'reg:bc']
        when 0x0C then instr = ['inc', 'reg:c']
        when 0x0D then instr = ['dec', 'reg:c']
        when 0x0E then instr = ['ld', 'reg:c', "imm8:#{@read8()}"]
        when 0x0F then instr = ['rrca']
        when 0x10 then instr = ['stop', "imm8:#{Tinify.hex(0, 2)}"]
        when 0x11 then instr = ['ld', 'reg:de', "imm16:#{@read16()}"]
        when 0x12 then instr = ['ld', 'indreg:(de)', 'reg:a']
        when 0x13 then instr = ['inc', 'reg:de']
        when 0x14 then instr = ['inc', 'reg:d']
        when 0x15 then instr = ['dec', 'reg:d']
        when 0x16 then instr = ['ld', 'reg:d', "imm8:#{@read8()}"]
        when 0x17 then instr = ['rla']
        when 0x18 then instr = ['jr', "add8:#{@read8()}"]
        when 0x19 then instr = ['add', 'reg:hl', 'reg:de']
        when 0x1A then instr = ['ld', 'reg:a', 'indreg:(de)']
        when 0x1B then instr = ['dec', 'reg:de']
        when 0x1C then instr = ['inc', 'reg:e']
        when 0x1D then instr = ['dec', 'reg:e']
        when 0x1E then instr = ['ld', 'reg:e', "imm8:#{@read8()}"]
        when 0x1F then instr = ['rra']
        when 0x20 then instr = ['jrnz', "add8:#{@read8()}"]
        when 0x21 then instr = ['ld', 'reg:hl', "imm16:#{@read16()}"]
        when 0x22 then instr = ['ld', 'indreg:(hl+)', 'reg:a']
        when 0x23 then instr = ['inc', 'reg:hl']
        when 0x24 then instr = ['inc', 'reg:h']
        when 0x25 then instr = ['dec', 'reg:h']
        when 0x26 then instr = ['ld', 'reg:h', "imm8:#{@read8()}"]
        when 0x27 then instr = ['daa']
        when 0x28 then instr = ['jrz', "add8:#{@read8()}"]
        when 0x29 then instr = ['add', 'reg:hl', 'reg:hl']
        when 0x2A then instr = ['ld', 'reg:a', 'indreg:(hl+)']
        when 0x2B then instr = ['dec', 'reg:hl']
        when 0x2C then instr = ['inc', 'reg:l']
        when 0x2D then instr = ['dec', 'reg:l']
        when 0x2E then instr = ['ld', 'reg:l', "imm8:#{@read8()}"]
        when 0x2F then instr = ['cpl']
        when 0x30 then instr = ['jrnc', "add8:#{@read8()}"]
        when 0x31 then instr = ['ld', 'reg:sp', "imm16:#{@read16()}"]
        when 0x32 then instr = ['ld', 'indreg:(hl-)', 'reg:a']
        when 0x33 then instr = ['inc', 'reg:sp']
        when 0x34 then instr = ['inc', 'indreg:(hl)']
        when 0x35 then instr = ['dec', 'indreg:(hl)']
        when 0x36 then instr = ['ld', 'indreg:(hl)', "imm8:#{@read8()}"]
        when 0x37 then instr = ['scf']
        when 0x38 then instr = ['jrc', "add8:#{@read8()}"]
        when 0x39 then instr = ['add', 'reg:hl', 'reg:sp']
        when 0x3A then instr = ['ld', 'reg:a', 'indreg:(hl-)']
        when 0x3B then instr = ['dec', 'reg:sp']
        when 0x3C then instr = ['inc', 'reg:a']
        when 0x3D then instr = ['dec', 'reg:a']
        when 0x3E then instr = ['ld', 'reg:a', "imm8:#{@read8()}"]
        when 0x3F then instr = ['ccf']
        when 0x40 then instr = ['ld', 'reg:b', 'reg:b']
        when 0x41 then instr = ['ld', 'reg:b', 'reg:c']
        when 0x42 then instr = ['ld', 'reg:b', 'reg:d']
        when 0x43 then instr = ['ld', 'reg:b', 'reg:e']
        when 0x44 then instr = ['ld', 'reg:b', 'reg:h']
        when 0x45 then instr = ['ld', 'reg:b', 'reg:l']
        when 0x46 then instr = ['ld', 'reg:b', 'indreg:(hl)']
        when 0x47 then instr = ['ld', 'reg:b', 'reg:a']
        when 0x48 then instr = ['ld', 'reg:c', 'reg:b']
        when 0x49 then instr = ['ld', 'reg:c', 'reg:c']
        when 0x4A then instr = ['ld', 'reg:c', 'reg:d']
        when 0x4B then instr = ['ld', 'reg:c', 'reg:e']
        when 0x4C then instr = ['ld', 'reg:c', 'reg:h']
        when 0x4D then instr = ['ld', 'reg:c', 'reg:l']
        when 0x4E then instr = ['ld', 'reg:c', 'indreg:(hl)']
        when 0x4F then instr = ['ld', 'reg:c', 'reg:a']
        when 0x50 then instr = ['ld', 'reg:d', 'reg:b']
        when 0x51 then instr = ['ld', 'reg:d', 'reg:c']
        when 0x52 then instr = ['ld', 'reg:d', 'reg:d']
        when 0x53 then instr = ['ld', 'reg:d', 'reg:e']
        when 0x54 then instr = ['ld', 'reg:d', 'reg:h']
        when 0x55 then instr = ['ld', 'reg:d', 'reg:l']
        when 0x56 then instr = ['ld', 'reg:d', 'indreg:(hl)']
        when 0x57 then instr = ['ld', 'reg:d', 'reg:a']
        when 0x58 then instr = ['ld', 'reg:e', 'reg:b']
        when 0x59 then instr = ['ld', 'reg:e', 'reg:c']
        when 0x5A then instr = ['ld', 'reg:e', 'reg:d']
        when 0x5B then instr = ['ld', 'reg:e', 'reg:e']
        when 0x5C then instr = ['ld', 'reg:e', 'reg:h']
        when 0x5D then instr = ['ld', 'reg:e', 'reg:l']
        when 0x5E then instr = ['ld', 'reg:e', 'indreg:(hl)']
        when 0x5F then instr = ['ld', 'reg:e', 'reg:a']
        when 0x60 then instr = ['ld', 'reg:h', 'reg:b']
        when 0x61 then instr = ['ld', 'reg:h', 'reg:c']
        when 0x62 then instr = ['ld', 'reg:h', 'reg:d']
        when 0x63 then instr = ['ld', 'reg:h', 'reg:e']
        when 0x64 then instr = ['ld', 'reg:h', 'reg:h']
        when 0x65 then instr = ['ld', 'reg:h', 'reg:l']
        when 0x66 then instr = ['ld', 'reg:h', 'indreg:(hl)']
        when 0x67 then instr = ['ld', 'reg:h', 'reg:a']
        when 0x68 then instr = ['ld', 'reg:l', 'reg:b']
        when 0x69 then instr = ['ld', 'reg:l', 'reg:c']
        when 0x6A then instr = ['ld', 'reg:l', 'reg:d']
        when 0x6B then instr = ['ld', 'reg:l', 'reg:e']
        when 0x6C then instr = ['ld', 'reg:l', 'reg:h']
        when 0x6D then instr = ['ld', 'reg:l', 'reg:l']
        when 0x6E then instr = ['ld', 'reg:l', 'indreg:(hl)']
        when 0x6F then instr = ['ld', 'reg:l', 'reg:a']
        when 0x70 then instr = ['ld', 'indreg:(hl)', 'reg:b']
        when 0x71 then instr = ['ld', 'indreg:(hl)', 'reg:c']
        when 0x72 then instr = ['ld', 'indreg:(hl)', 'reg:d']
        when 0x73 then instr = ['ld', 'indreg:(hl)', 'reg:e']
        when 0x74 then instr = ['ld', 'indreg:(hl)', 'reg:h']
        when 0x75 then instr = ['ld', 'indreg:(hl)', 'reg:l']
        when 0x76 then instr = ['halt']
        when 0x77 then instr = ['ld', 'indreg:(hl)', 'reg:a']
        when 0x78 then instr = ['ld', 'reg:a', 'reg:b']
        when 0x79 then instr = ['ld', 'reg:a', 'reg:c']
        when 0x7A then instr = ['ld', 'reg:a', 'reg:d']
        when 0x7B then instr = ['ld', 'reg:a', 'reg:e']
        when 0x7C then instr = ['ld', 'reg:a', 'reg:h']
        when 0x7D then instr = ['ld', 'reg:a', 'reg:l']
        when 0x7E then instr = ['ld', 'reg:a', 'indreg:(hl)']
        when 0x7F then instr = ['ld', 'reg:a', 'reg:a']
        # Note: the first reg:a could be omitted, as there's no
        # way to add, adc, sub or sbc to other registers than a.
        when 0x80 then instr = ['add', 'reg:a', 'reg:b']
        when 0x81 then instr = ['add', 'reg:a', 'reg:c']
        when 0x82 then instr = ['add', 'reg:a', 'reg:d']
        when 0x83 then instr = ['add', 'reg:a', 'reg:e']
        when 0x84 then instr = ['add', 'reg:a', 'reg:h']
        when 0x85 then instr = ['add', 'reg:a', 'reg:l']
        when 0x86 then instr = ['add', 'reg:a', 'indreg:(hl)']
        when 0x87 then instr = ['add', 'reg:a', 'reg:a']
        when 0x88 then instr = ['adc', 'reg:a', 'reg:b']
        when 0x89 then instr = ['adc', 'reg:a', 'reg:c']
        when 0x8A then instr = ['adc', 'reg:a', 'reg:d']
        when 0x8B then instr = ['adc', 'reg:a', 'reg:e']
        when 0x8C then instr = ['adc', 'reg:a', 'reg:h']
        when 0x8D then instr = ['adc', 'reg:a', 'reg:l']
        when 0x8E then instr = ['adc', 'reg:a', 'indreg:(hl)']
        when 0x8F then instr = ['adc', 'reg:a', 'reg:a']
        when 0x90 then instr = ['sub', 'reg:a', 'reg:b']
        when 0x91 then instr = ['sub', 'reg:a', 'reg:c']
        when 0x92 then instr = ['sub', 'reg:a', 'reg:d']
        when 0x93 then instr = ['sub', 'reg:a', 'reg:e']
        when 0x94 then instr = ['sub', 'reg:a', 'reg:h']
        when 0x95 then instr = ['sub', 'reg:a', 'reg:l']
        when 0x96 then instr = ['sub', 'reg:a', 'indreg:(hl)']
        when 0x97 then instr = ['sub', 'reg:a', 'reg:a']
        when 0x98 then instr = ['sbc', 'reg:a', 'reg:b']
        when 0x99 then instr = ['sbc', 'reg:a', 'reg:c']
        when 0x9A then instr = ['sbc', 'reg:a', 'reg:d']
        when 0x9B then instr = ['sbc', 'reg:a', 'reg:e']
        when 0x9C then instr = ['sbc', 'reg:a', 'reg:h']
        when 0x9D then instr = ['sbc', 'reg:a', 'reg:l']
        when 0x9E then instr = ['sbc', 'reg:a', 'indreg:(hl)']
        when 0x9F then instr = ['sbc', 'reg:a', 'reg:a']
        when 0xA0 then instr = ['and', 'reg:a', 'reg:b']
        when 0xA1 then instr = ['and', 'reg:a', 'reg:c']
        when 0xA2 then instr = ['and', 'reg:a', 'reg:d']
        when 0xA3 then instr = ['and', 'reg:a', 'reg:e']
        when 0xA4 then instr = ['and', 'reg:a', 'reg:h']
        when 0xA5 then instr = ['and', 'reg:a', 'reg:l']
        when 0xA6 then instr = ['and', 'reg:a', 'indreg:(hl)']
        when 0xA7 then instr = ['and', 'reg:a', 'reg:a']
        when 0xA8 then instr = ['xor', 'reg:a', 'reg:b']
        when 0xA9 then instr = ['xor', 'reg:a', 'reg:c']
        when 0xAA then instr = ['xor', 'reg:a', 'reg:d']
        when 0xAB then instr = ['xor', 'reg:a', 'reg:e']
        when 0xAC then instr = ['xor', 'reg:a', 'reg:h']
        when 0xAD then instr = ['xor', 'reg:a', 'reg:l']
        when 0xAE then instr = ['xor', 'reg:a', 'indreg:(hl)']
        when 0xAF then instr = ['xor', 'reg:a', 'reg:a']
        when 0xB0 then instr = ['or', 'reg:a', 'reg:b']
        when 0xB1 then instr = ['or', 'reg:a', 'reg:c']
        when 0xB2 then instr = ['or', 'reg:a', 'reg:d']
        when 0xB3 then instr = ['or', 'reg:a', 'reg:e']
        when 0xB4 then instr = ['or', 'reg:a', 'reg:h']
        when 0xB5 then instr = ['or', 'reg:a', 'reg:l']
        when 0xB6 then instr = ['or', 'reg:a', 'indreg:(hl)']
        when 0xB7 then instr = ['or', 'reg:a', 'reg:a']
        when 0xB8 then instr = ['cp', 'reg:a', 'reg:b']
        when 0xB9 then instr = ['cp', 'reg:a', 'reg:c']
        when 0xBA then instr = ['cp', 'reg:a', 'reg:d']
        when 0xBB then instr = ['cp', 'reg:a', 'reg:e']
        when 0xBC then instr = ['cp', 'reg:a', 'reg:h']
        when 0xBD then instr = ['cp', 'reg:a', 'reg:l']
        when 0xBE then instr = ['cp', 'reg:a', 'indreg:(hl)']
        when 0xBF then instr = ['cp', 'reg:a', 'reg:a']
        # Previous comment up to here
        when 0xC0 then instr = ['retnz']
        when 0xC1 then instr = ['pop', 'reg:bc']
        when 0xC2 then instr = ['jpnz', "add16:#{@read16()}"]
        when 0xC3 then instr = ['jp', "add16:#{@read16()}"]
        when 0xC4 then instr = ['callnz', "add16:#{@read16()}"]
        when 0xC5 then instr = ['push', 'reg:bc']
        when 0xC6 then instr = ['add', 'reg:a', "imm8:#{@read8()}"]
        when 0xC7 then instr = ['rst', "imm8:#{Tinify.hex(0, 2)}"]
        when 0xC8 then instr = ['retz']
        when 0xC9 then instr = ['ret']
        when 0xCA then instr = ['jpz', "add16:#{@read16()}"]
        # 0xCB is treated at the bottom, as it's a real pain.
        when 0xCC then instr = ['callz', "add16:#{@read16()}"]
        when 0xCD then instr = ['call', "add16:#{@read16()}"]
        when 0xCE then instr = ['adc', 'reg:a', "imm8:#{@read8()}"]
        when 0xCF then instr = ['rst', "imm8:#{Tinify.hex(8, 2)}"]
        when 0xD0 then instr = ['retnc']
        when 0xD1 then instr = ['pop', 'reg:hl']
        when 0xD2 then instr = ['jpnc', "add16:#{@read16()}"]
        # 0xDE missing
        when 0xD4 then instr = ['callnc', "add16:#{@read16()}"]
        when 0xD5 then instr = ['push', 'reg:de']
        when 0xD6 then instr = ['sub', 'reg:a', "imm8:#{@read8()}"]
        when 0xD7 then instr = ['rst', "imm8:#{Tinify.hex(16, 2)}"]
        when 0xD8 then instr = ['retc']
        when 0xD9 then instr = ['reti']
        when 0xDA then instr = ['jpc', "add16:#{@read16()}"]
        # 0xDB missing
        when 0xDC then instr = ['callc', "add16:#{@read16()}"]
        # 0xDD missing
        when 0xDE then instr = ['sbc', 'reg:a', "imm8:#{@read8()}"]
        when 0xDF then instr = ['rst', "imm8:#{Tinify.hex(24, 2)}"]
        when 0xE0 then instr = ['ldh', "ind8:(#{@read8()})", 'reg:a']
        when 0xE1 then instr = ['pop', 'reg:hl']
        when 0xE2 then instr = ['ld', 'indreg:(c)', 'reg:a']
        # 0xE3 missing
        # 0xE4 missing
        when 0xE5 then instr = ['push', 'reg:hl']
        when 0xE6 then instr = ['and', 'reg:a', "imm8:#{@read8()}"]
        when 0xE7 then instr = ['rst', "imm8:#{Tinify.hex(32, 2)}"]
        when 0xE8 then instr = ['add', 'reg:sp', "imm8:#{@read8()}"]
        when 0xE9 then instr = ['jp', 'indreg:(hl)']
        when 0xEA then instr = ['ld', "ind16:(#{@read16()})", 'reg:a']
        # 0xEB missing
        # 0xEC missing
        # 0xED missing
        when 0xEE then instr = ['xor', 'reg:a', "imm8:#{@read8()}"]
        when 0xEF then instr = ['rst', "imm8:#{Tinify.hex(40, 2)}"]

        when 0xF0 then instr = ['ldh', 'reg:a', "ind8:(#{@read8()})"]
        when 0xF1 then instr = ['pop', 'reg:af']
        when 0xF2 then instr = ['ld', 'reg:a', 'indreg:(c)']
        when 0xF3 then instr = ['di']
        # 0xF4 missing
        when 0xF5 then instr = ['push', 'reg:af']
        when 0xF6 then instr = ['or', 'reg:a', "imm8:#{@read8()}"]
        when 0xF7 then instr = ['rst', "imm8:#{Tinify.hex(48, 2)}"]
        when 0xF8 then instr = ['ld', 'reg:hl', "imm8:SP + #{@read8()}"]
        when 0xF9 then instr = ['ld', 'reg:sp', 'reg:hl']
        when 0xFA then instr = ['ld', 'reg:a', "ind16:(#{@read16()})"]
        when 0xFB then instr = ['ei']
        # 0xFC missing
        # 0xFD missing
        when 0xFE then instr = ['cp', 'reg:a', "imm8:#{@read8()}"]
        when 0xFF then instr = ['rst', "imm8:#{Tinify.hex(56, 2)}"]
        when 0xCB
          b1 = @read8(false)
          regs = ['reg:b', 'reg:c', 'reg:d', 'reg:e', 'reg:h', 'reg:l', 'indreg:(hl)', 'reg:a']
          if b1 >= 0x00 and b1 <= 0x07
            instr = ['rlc', regs[b1]]
          else if b1 >= 0x08 and b1 <= 0x0F
            instr = ['rrc', regs[b1 % 8]]
          else if b1 >= 0x10 and b1 <= 0x17
            instr = ['rl', regs[b1 % 8]]
          else if b1 >= 0x18 and b1 <= 0x1F
            instr = ['rr', regs[b1 % 8]]
          else if b1 >= 0x20 and b1 <= 0x27
            instr = ['sla', regs[b1 % 8]]
          else if b1 >= 0x28 and b1 <= 0x2F
            instr = ['sra', regs[b1 % 8]]
          else if b1 >= 0x30 and b1 <= 0x37
            instr = ['swap', regs[b1 % 8]]
          else if b1 >= 0x38 and b1 <= 0x3F
            instr = ['srl', regs[b1 % 8]]
          else if b1 >= 0x40 and b1 <= 0x7F
            instr = ['bit', "bit:#{(b1 - 0x40) >> 3}", regs[b1 % 8]]
          else if b1 >= 0x80 and b1 <= 0xBF
            instr = ['set', "bit:#{(b1 - 0x80) >> 3}", regs[b1 % 8]]
          else if b1 >= 0xC0 and b1 <= 0xFF
            instr = ['rst', "bit:#{(b1 - 0xB0) >> 3}", regs[b1 % 8]]
        else
          console.log "ERROR"

      if instr
        ret += Tinify.instr(instr) + "<br/>"
      b0 = b1 = null
      instr = null

    console.log "FINIE"

    ret
