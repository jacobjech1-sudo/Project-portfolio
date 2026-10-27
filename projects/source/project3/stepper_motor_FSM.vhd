LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY stepper_motor_FSM IS
    PORT(clk, dir, en : IN  STD_LOGIC;
        q             : OUT STD_LOGIC_VECTOR(3 downto 0));
END stepper_motor_FSM;

ARCHITECTURE arch OF stepper_motor_FSM IS
    TYPE state_type IS (s0,s1,s2,s3,s4); --NEED TO PUT IN STATES
    SIGNAL state: state_type;
BEGIN
    PROCESS (clk)
    BEGIN
        IF clk'EVENT AND clk = '1' THEN
            IF en = '1' AND dir = '1' THEN --Clockwise steps
                case state is
                    when s0 => state <= s1;
                    when s1 => state <= s2;
                    when s2 => state <= s3;
                    when s3 => state <= s4;
                    when s4 => state <= s1;
                    when others => state <= s0;
                 end case;
   
            ELSIF en = '1' AND dir = '0' THEN --Counter clockwise steps
                case state is
                    when s0 => state <= s4;
                    when s4 => state <= s3;
                    when s3 => state <= s2;
                    when s2 => state <= s1;
                    when s1 => state <= s4;
                    when others => state <= s0;
                 end case;
            
            
            
            ELSIF en = '0' THEN
--                case state is
--                    when s0 => state <= s0;
--                    when s4 => state <= s0;
--                    when s3 => state <= s0;
--                    when s2 => state <= s0;
--                    when s1 => state <= s0;
                    
--                 end case;
                state <= s0;
            
            
            END IF;
         END IF;
END PROCESS;
            
WITH state SELECT
    
    q <= "0001" when s1,
         "0010" when s2,
         "0100" when s3,
         "1000" when s4,
         "0000" when others;

    
END arch;

