-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity read_8b_tb is
end;

architecture bench of read_8b_tb is

  component read_8b
  Port (
      rst : in std_logic;
      clk : in std_logic;
      msg_read : out std_logic_vector (7 downto 0);	
      start : in std_logic;
      oneW_out : out std_logic;
  	  oneW_in : in std_logic;	
      cond_tri_state : out std_logic;	
      read_8b_done : out std_logic);
  end component;

  signal rst: std_logic;
  signal clk: std_logic;
  signal msg_read: std_logic_vector (7 downto 0);
  signal start: std_logic;
  signal oneW_out: std_logic;
  signal oneW_in: std_logic;
  signal cond_tri_state: std_logic;
  signal read_8b_done: std_logic;

  constant clk_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: read_8b port map ( rst            => rst,
                          clk            => clk,
                          msg_read       => msg_read,
                          start          => start,
                          oneW_out       => oneW_out,
                          oneW_in        => oneW_in,
                          cond_tri_state => cond_tri_state,
                          read_8b_done   => read_8b_done );

     clk_process :process
begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
end process;

rst <= '1' after 8ns, '0' after 101 ns;
oneW_in <= '0' after 11 ns, '1' after 62 us, '0' after 94 us;
start <= '1' after 151 ns, '0' after 181 ns;
end;
  