-----------------------------------------------------------------------------------
-- File:        counter_tb.vhd
-- Date:        20211014
-- Author:      Lucas A. Kammann
-- Description: Testbench to validate the counter
-----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-----------------------------------------------------------------------------------
-- Entity
-----------------------------------------------------------------------------------
entity counter_tb is
end entity counter_tb;

-----------------------------------------------------------------------------------
-- Architecture
-----------------------------------------------------------------------------------
architecture counter_tb_arc of counter_tb is
    signal clock    : std_logic := '0';
    signal reset    : std_logic := '0';
    signal enable   : std_logic := '0';
    signal q        : std_logic_vector (3 downto 0) := "0000";
begin
    -- Creating an instance of the counter
    instance: entity work.counter(counter_arc)
		generic map (
			word_width => 4
		)
        port map (
            clock => clock,
            reset => reset,
            enable => enable,
            q => q
        );
    
    -- Generates the signals waveforms for the testbench
    clock <= not clock after 10 ns;
    enable <= '1' after 40 ns;
    reset <= '1', '0' after 10 ns, '1' after 1000 ns;
    
end architecture counter_tb_arc;