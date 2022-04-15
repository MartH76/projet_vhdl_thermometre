-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity NegToPos_tb is
end;

architecture bench of NegToPos_tb is

  component NegToPos
  Port ( 
      temp_buff : in std_logic_vector(15 downto 0);
      sign : out std_logic;
      virgule : out std_logic;
      clk : in std_logic;
      rst : in std_logic;
      temp_8b : out std_logic_vector(7 downto 0));
  end component;

  signal temp_buff: std_logic_vector(15 downto 0);
  signal sign: std_logic;
  signal virgule: std_logic;
  signal clk: std_logic;
  signal rst: std_logic;
  signal temp_8b: std_logic_vector(7 downto 0);

  constant clk_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: NegToPos port map ( temp_buff => temp_buff,
                           sign      => sign,
                           virgule   => virgule,
                           clk       => clk,
                           rst       => rst,
                           temp_8b   => temp_8b );


 clk_process :process
begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
end process;

rst <= '1' after 8ns, '0' after 101 ns;
temp_buff <= "1111111111001110" after 42 ns;

end;
  