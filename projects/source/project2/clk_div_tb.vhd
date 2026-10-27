
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clk_div_tb is
--  Port ( );
end clk_div_tb;

architecture Behavioral of clk_div_tb is
    constant clk_period: time := 10 ns;
    signal reset, clk_in, clk_out: std_logic;
begin
    UUT: entity work.clk_div
    generic map (clk_in_freq => 100000000, clk_out_freq => 1)
    port map (reset => reset, clk_in => clk_in, clk_out => clk_out);
    clk_proc: process 
     begin
         Clk_in <= '0';
         wait for clk_period/2;
         Clk_in <= '1';
         wait for clk_period/2;
     end process;
     stim_proc: process
     begin
        reset <= '1';
        wait for clk_period;
        
        reset <= '0';
        wait;
     end process;
end Behavioral;
