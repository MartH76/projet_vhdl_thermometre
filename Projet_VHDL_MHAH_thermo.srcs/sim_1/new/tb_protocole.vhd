-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity protocol_tb is
end;

architecture bench of protocol_tb is

  component protocol
  Port ( 
      clk : in std_logic;
      rst : in std_logic;
      start_protocol : in std_logic;
      timer : in std_logic;
      oneW_synchro : in std_logic;
      oneW_out : out std_logic;
      ready : out std_logic;
      cond_tri_state : out std_logic;
      temp : out std_logic_vector(15 downto 0));
  end component;

  signal clk: std_logic:='0';
  signal rst: std_logic;
  signal start_protocol: std_logic;
  signal timer: std_logic:='0';
  signal oneW_synchro: std_logic:='0';
  signal oneW_out: std_logic;
  signal ready: std_logic;
  signal cond_tri_state: std_logic;
  signal temp: std_logic_vector(15 downto 0);

  constant clk_period: time := 10 ns;
  constant tmr_period :time := 1 us;
begin

  uut: protocol port map ( clk            => clk,
                           rst            => rst,
                           start_protocol => start_protocol,
                           timer          => timer,
                           oneW_synchro   => oneW_synchro,
                           oneW_out       => oneW_out,
                           ready          => ready,
                           cond_tri_state => cond_tri_state,
                           temp           => temp );


clk_process :process
begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
end process;

tmr_process :process
begin
		timer <= '0';
		wait for tmr_period/2;
		timer <= '1';
		wait for tmr_period/2;
end process;

rst <= '1' after 8ns, '0' after 101 ns;
start_protocol <= '1' after 151 ns, '0' after 181 ns;
oneW_synchro <= '1' after 100 us, '0' after 101 us;
end;