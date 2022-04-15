-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity write_8b_tb is
end;

architecture bench of write_8b_tb is

  component write_8b
  Port (
      rst : in std_logic;
      clk : in std_logic;
      word : in std_logic_vector (7 downto 0);
      start : in std_logic;
      oneW_out : out std_logic;
      cond_tri_state : out std_logic;
      write_8b_done : out std_logic);
  end component;

  signal rst: std_logic;
  signal clk: std_logic;
  signal word: std_logic_vector (7 downto 0);
  signal start: std_logic;
  signal oneW_out: std_logic;
  signal cond_tri_state: std_logic;
  signal write_8b_done: std_logic;

  constant clk_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: write_8b port map ( rst            => rst,
                           clk            => clk,
                           word           => word,
                           start          => start,
                           oneW_out       => oneW_out,
                           cond_tri_state => cond_tri_state,
                           write_8b_done  => write_8b_done );

    clk_process :process
begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
end process;

rst <= '1' after 8ns, '0' after 101 ns;
word <= "11001100" after 12 ns;
start <= '1' after 151 ns, '0' after 181 ns;

end;