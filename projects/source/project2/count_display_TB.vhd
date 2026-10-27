library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity count_display_tb is
end count_display_tb;

architecture sim of count_display_tb is

    signal clock     : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '0';
    signal btn_event : STD_LOGIC := '0';
    signal leds      : STD_LOGIC_VECTOR (3 downto 0);
    signal sevenseg  : STD_LOGIC_VECTOR (6 downto 0);
    signal anode     : STD_LOGIC_VECTOR (3 downto 0);

begin

    uut: entity work.count_display
        port map ( clock    => clock,
                   reset    => reset,
                   inc    => btn_event,
                   leds     => leds,
                   sevenseg => sevenseg,
                   anode    => anode );

    -- 100 MHz clock (10 ns period)
    clock <= not clock after 5 ns;

    stim: process
    begin
        -- initial reset
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;
        assert leds = "0000" report "Count should be 0 after reset" severity error;

        -- bounce on press: short glitches that should be ignored
        for i in 1 to 5 loop
            btn_event <= '1';
            wait for 1 us;
            btn_event <= '0';
            wait for 1 us;
        end loop;
        wait for 1 ms;
        assert leds = "0000" report "Bounce should not increment the count" severity error;

        -- press 1: held longer than the 20 ms debounce time
        btn_event <= '1';
        wait for 25 ms;
        assert leds = "0001" report "Count should be 1 after first press" severity error;
        btn_event <= '0';
        wait for 25 ms;   -- release must also be stable before the next press

        -- press 2
        btn_event <= '1';
        wait for 25 ms;
        assert leds = "0010" report "Count should be 2 after second press" severity error;
        btn_event <= '0';
        wait for 25 ms;

        -- reset button
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;
        assert leds = "0000" report "Count should be 0 after reset" severity error;

        report "Testbench finished" severity note;
        wait;
    end process;

end sim;
