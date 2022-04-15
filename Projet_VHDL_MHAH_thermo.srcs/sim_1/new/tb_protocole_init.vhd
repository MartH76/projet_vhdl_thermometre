
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity protocole_init_tb is
end;

architecture bench of protocole_init_tb is

  component protocole_init
  Port (
      cmd_init : in std_logic;
      rst : in std_logic;
      clk : in std_logic;
--      timer : in std_logic;
      oneW_in : in std_logic;
      oneW_out : out std_logic;
      cond_tri_state : out std_logic;
      init_done : out std_logic);
  end component;

  signal cmd_init: std_logic;
  signal rst: std_logic;
  signal clk: std_logic;
  signal timer: std_logic;
  signal oneW_in: std_logic;
  signal oneW_out: std_logic;
  signal cond_tri_state: std_logic;
  signal init_done: std_logic;
  
  constant clk_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: protocole_init port map ( cmd_init       => cmd_init,
                                 rst            => rst,
                                 clk            => clk,
                                -- timer          => timer,
                                 oneW_in        => oneW_in,
                                 oneW_out       => oneW_out,
                                 cond_tri_state => cond_tri_state,
                                 init_done      => init_done );

 

  clk_process :process
begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
end process;

rst <= '1' after 8ns, '0' after 101 ns;
cmd_init <= '1' after 150ns, '0' after 231 ns;
oneW_in <= '0' after 537us, '1' after 647us;

end;
