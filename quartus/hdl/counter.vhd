-----------------------------------------------------------------------------------
-- File:        counter.vhd
-- Date:        20211014
-- Author:      Lucas A. Kammann
-- Description: N-bit counter module
-----------------------------------------------------------------------------------
library ieee;				 
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------------------------------------
-- Entity
-----------------------------------------------------------------------------------
entity counter is
    generic(
        word_width  : integer := 4
    );
    port(
        signal clock    : in std_logic := '0';										-- Clock
        signal reset    : in std_logic := '0';										-- Asynchronous reset
        signal enable   : in std_logic := '0';										-- Enables the clock
		  signal updown	: in std_logic := '0';										-- Counts up then down if '1'
        signal q        : out std_logic_vector (word_width - 1 downto 0)	-- Output
    );
end entity counter;

-----------------------------------------------------------------------------------
-- Architecture
-----------------------------------------------------------------------------------
architecture counter_arc of counter is
	 constant modulus	: integer := 2**word_width - 1;
	 
    signal counter  	: std_logic_vector (word_width - 1 downto 0);
	 signal direction	: std_logic;
begin

    -- Update the internal counter value each rising edge of the clock
    -- and verify if the asynchronous reset has been asserted to set
    -- all internal values to default
    update_count: process (clock, reset)
    begin
        if (reset = '1') then
            counter <= (others => '0');
				direction <= '0';
        elsif (rising_edge(clock) and enable = '1') then
				if (updown = '0') then
					if (counter = modulus) then
						counter <= (others => '0');
					else
						counter <= counter + 1;
					end if;
				else
					if (direction = '1') then
						if (counter = 0) then
							counter <= counter + 1;
							direction <= '0';
						else
							counter <= counter - 1;
						end if;
					else
						if (counter = modulus) then
							counter <= counter - 1;
							direction <= '1';
						else
							counter <= counter + 1;
						end if;
					end if;
				end if;
        end if;
    end process update_count;

    -- Connect the internal count with the module's output
    q <= counter;

end architecture counter_arc;