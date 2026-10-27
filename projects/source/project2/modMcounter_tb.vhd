library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity modMcounter_tb is
--  Port ( );
end modMcounter_tb;

architecture Behavioral of modMcounter_tb is
    constant N : integer := 4;
    constant clk_period: time := 10 ns;
    signal  clk, reset : std_logic := '0';
    signal  count : std_logic_vector(N-1 downto 0); 
begin
    UUT: entity work.modMcounter generic map (N => N) 
         port map(reset => reset, clk => clk, count => count);
    
    --clk_process
     clk_proc: process 
     begin
         Clk <= '0';
         wait for clk_period/2;
         Clk <= '1';
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
