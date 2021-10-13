-----------------------------------------------------------------------------------
-- File:        pwm_tb.vhd
-- Date:        20211014
-- Author:      Lucas A. Kammann
-- Description: Testbench for the PWM module
-----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;

-----------------------------------------------------------------------------------
-- Entity
-----------------------------------------------------------------------------------
entity pwm_tb is
end entity pwm_tb;

-----------------------------------------------------------------------------------
-- Architecture
-----------------------------------------------------------------------------------
architecture pwm_tb_arc of pwm_tb is
	signal clock    	: std_logic := '0';
	signal reset_n		: std_logic := '1';
	signal enable		: std_logic := '1';
	signal pwm_out		: std_logic := '0';  
	signal pwm_n_out	: std_logic := '0';
	signal duty			: std_logic_vector (2 downto 0) := "000";
	signal tick			: std_logic := '0';
begin
	
	-- Create an instance of the PWM module
    module: entity work.pwm(pwm_arc)
		generic map (
			sys_clock => 80,
			pwm_frequency => 10,
			bits_resolution => 3
		)
        port map (
			clock => clock ,
			reset_n => reset_n,
			enable => enable,
			pwm_out => pwm_out,
			pwm_n_out => pwm_n_out,
			duty => duty
        );
    
	-- Generates the signals for the testbench
    clock <= not clock after 10 ns;
	tick <= not tick after 240 ns;
	enable <= not enable after 2400 ns;
	reset_n <= not reset_n after 4800 ns;

	update_duty: process (tick)
	begin
		if tick = '1' then
			if duty = "111" then
				duty <= "000";
			else
				duty <= std_logic_vector(unsigned(duty) + 1);
			end if;
		end if;
	end process update_duty;

end architecture pwm_tb_arc;