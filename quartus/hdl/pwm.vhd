-----------------------------------------------------------------------------------
-- File:        pwm.vhd
-- Date:        20211014
-- Author:      Lucas A. Kammann
-- Description: PWM module
-----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------------------------------------------------------------------------------
-- Entity
-----------------------------------------------------------------------------------
entity pwm is
    generic(
        sys_clock       : integer := 50000000;  -- System's clock frequency
        pwm_frequency   : integer := 100;  		-- PWM frequency
        bits_resolution : integer := 8  			-- Amount of bits for the duty
    );
    port(
        signal clock        : in std_logic;                                         -- Clock
        signal reset_n      : in std_logic;                                         -- Reset the status of the module
        signal enable       : in std_logic;                                         -- Enables updating the duty value each rising edge of the clock
        signal duty         : in std_logic_vector (bits_resolution - 1 downto 0);   -- Configuration of duty
        signal pwm_out      : out std_logic;                                        -- Output of the PWM module
        signal pwm_n_out    : out std_logic                                         -- Inverted phase output of the PWM module
    );
end entity pwm;

-----------------------------------------------------------------------------------
-- Architecture
-----------------------------------------------------------------------------------
architecture pwm_arc of pwm is
    constant period     : integer := sys_clock / pwm_frequency;
    signal counter      : integer := 0;
    signal duty_count   : integer := 0;
begin

    -- Each rising edge of the clock, if the update function is enabled,
    -- latches the new value of duty for the PWM
    update_duty: process (clock)
    begin
        if (rising_edge(clock) and enable = '1') then
            duty_count <= period * to_integer(unsigned(duty)) / (2**bits_resolution - 1);
        end if;
    end process update_duty;

    -- Free running counter used to generate the periodic
    -- signal to control the square waveform and its duty
    update_counter: process (clock, reset_n)
    begin
        if (reset_n = '0') then
            counter <= 0;
        elsif rising_edge(clock) then
            if (counter = (period - 1)) then
                counter <= 0;
            else
                counter <= counter + 1; 
            end if;
        end if;
    end process update_counter;

    -- Controls the output signal according to the threshold value
    -- and the free running counter
    update_output: process (counter, reset_n)
    begin
        if (reset_n = '0') then
            pwm_out <= '0';
            pwm_n_out <= '0';
        elsif (counter < duty_count) then
            pwm_out <= '1';
            pwm_n_out <= '0';
        else
            pwm_out <= '0';
            pwm_n_out <= '1';
        end if;
    end process update_output;

end architecture pwm_arc;