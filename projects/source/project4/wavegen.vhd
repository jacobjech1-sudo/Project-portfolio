library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sine_package.all;
 
 

entity wavegen is
  port( clock, reset, enable: in std_logic;
        wave_sel : in STD_LOGIC_VECTOR (1 downto 0);
        wave_out: out std_logic_vector(data_bits - 1 downto 0);
        JA: out std_logic_vector (data_bits - 1 downto 0));
end;

architecture arch1 of wavegen is
      signal addr: integer range 0 to max_address;
	  --2. declare a signal sine_table of type ROM_type
	  signal sine_table : ROM_type;
	  signal triangle_table : ROM_type;
	  signal square_table : ROM_type;
       
	   
      signal sine_vector: std_logic_vector(data_bits - 1 downto 0);
      signal triangle_vector: STD_LOGIC_VECTOR(data_bits - 1 downto 0);
      signal square_vector: STD_LOGIC_VECTOR(data_bits - 1 downto 0);
      signal selected : std_logic_vector(data_bits - 1 downto 0);
begin
    --3. call the function sine_rom defined in the package and store results in signal sine_table
    sine_table <= sine_rom;
    triangle_table <= triangle_rom;
    square_table <= square_rom;
     
	 
    process (clock,reset)
    begin
        if (reset = '1') then
            sine_vector <= (others => '0');
            triangle_vector <= (others => '0');
            square_vector <= (others => '0');
            addr <= 0;
        elsif (rising_edge (clock)) then
            if (enable = '1') then 
			    --4. sine_vector = the value in the "sine_table" at location "addr". Note data types must be matched between LHS and RHS
			    sine_vector <= STD_LOGIC_VECTOR(sine_table(addr));
			    triangle_vector <= STD_LOGIC_VECTOR(triangle_table(addr));
			    square_vector <= STD_LOGIC_VECTOR(square_table(addr));
                 
                if (addr = max_address)then
                      addr <= 0;
                else
                      addr <= addr + 1;
                end if;
            end if;
        end if;
    
    
    end process;
    
    process (wave_sel, sine_vector, triangle_vector, square_vector)
    begin
    case wave_sel is
        when "00" => selected <= sine_vector;
        when "01" => selected <= triangle_vector;
        when "10" => selected <= square_vector;
        when others => selected <= (others => '0');
        
       end case;
       end process;
        wave_out <= selected;
       JA <= selected;
end;

