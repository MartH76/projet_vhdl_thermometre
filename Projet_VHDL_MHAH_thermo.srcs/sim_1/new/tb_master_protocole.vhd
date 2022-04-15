-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity master_protocole_tb is
end;

architecture bench of master_protocole_tb is

  component master_protocole
  Port (clk : in std_logic;
        rst : in std_logic;
        init_done : in std_logic;
        write_8b_done : in std_logic;
        read_8b_done : in std_logic;
        start_protocole : in std_logic;
        oneW_in : in std_logic;
        word_read : in std_logic_vector(7 downto 0);
        temp : out std_logic_vector(15 downto 0);
        ready : out std_logic;
        cmd_init : out std_logic;
        start_read : out std_logic;
        start_write : out std_logic;
        word_write : out std_logic_vector(7 downto 0)
        );
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal init_done: std_logic;
  signal write_8b_done: std_logic;
  signal read_8b_done: std_logic;
  signal start_protocole: std_logic;
  signal timer: std_logic;
  signal oneW_in: std_logic;
  signal word_read: std_logic_vector(7 downto 0);
  signal temp: std_logic_vector(15 downto 0);
  signal ready: std_logic;
  signal cmd_init: std_logic;
  signal start_read: std_logic;
  signal start_write: std_logic;
  signal word_write: std_logic_vector(7 downto 0) ;

  constant clk_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: master_protocole port map ( clk             => clk,
                                   rst             => rst,
                                   init_done       => init_done,
                                   write_8b_done   => write_8b_done,
                                   read_8b_done    => read_8b_done,
                                   start_protocole => start_protocole,
                                   oneW_in         => oneW_in,
                                   word_read       => word_read,
                                   temp            => temp,
                                   ready           => ready,
                                   cmd_init        => cmd_init,
                                   start_read      => start_read,
                                   start_write     => start_write,
                                   word_write      => word_write );

     clk_process :process
begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
end process;

rst <= '1' after 8ns, '0' after 101 ns;
oneW_in <= '0' after 11 ns, '1' after 62 us;
start_protocole <= '1' after 151 ns, '0' after 181 ns;
init_done <= '1' after 11ns;
write_8b_done <= '1' after 11ns;
read_8b_done <= '1' after 11ns;
word_read <= "10100110" after 11ns;

end;