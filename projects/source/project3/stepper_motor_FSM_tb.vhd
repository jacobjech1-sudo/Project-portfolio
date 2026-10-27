library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stepper_motor_FSM_tb is
--  Port ( );
end stepper_motor_FSM_tb;

architecture Behavioral of stepper_motor_FSM_tb is
signal dir : std_logic := '1';
signal clk: std_logic  := '0';
signal en: std_logic := '1';
signal q: std_logic_vector(3 downto 0);


begin
    UUT: entity work.stepper_motor_FSM
        port map (
        clk => clk,
        dir => dir,
        en => en,
        q => q );
        

    test: process
    begin 
        clk <= '0'; 
        wait for 10us;
        clk <= '1';
        wait for 10us;
    end process;
    
    direction : process
    begin
    
    en <= '1';
    dir <= '1';
    wait for 1000us;
    
    dir <= '0';
    
    wait for 1000us;
    end process;
    


end Behavioral;



