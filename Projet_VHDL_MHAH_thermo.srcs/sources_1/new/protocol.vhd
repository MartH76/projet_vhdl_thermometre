----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2022 09:07:37
-- Design Name: 
-- Module Name: protocol - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity protocol is
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
end protocol;


architecture Behavioral of protocol is


component protocole_init is --On fait une FSM de Mealy
Port (
    cmd_init : in std_logic;
    rst : in std_logic;
    clk : in std_logic;
    timer : in std_logic;
    oneW_in : in std_logic;
    oneW_out : out std_logic;
    cond_tri_state : out std_logic;
    init_done : out std_logic);
end component;

component master_protocole is
Port (clk : in std_logic;
      rst : in std_logic;
      init_done : in std_logic;
      write_8b_done : in std_logic;
      read_8b_done : in std_logic;
      start_protocole : in std_logic;
      timer : in std_logic;
      oneW_in : in std_logic;
      word_read : in std_logic_vector(7 downto 0);
      temp : out std_logic_vector(15 downto 0);
      
      ready : out std_logic;
      cmd_init : out std_logic;
      start_read : out std_logic;
      start_write : out std_logic;
     
      word_write : out std_logic_vector(7 downto 0));
end component;

component read_8b is
Port (
    rst : in std_logic;
    clk : in std_logic;
    msg_read : out std_logic_vector (7 downto 0);	
    start : in std_logic;
    timer : in std_logic;
    oneW_out : out std_logic;
	oneW_in : in std_logic;	
    cond_tri_state : out std_logic;	
    read_8b_done : out std_logic);
end component;

component write_8b is
Port (
    rst : in std_logic;
    clk : in std_logic;
    word : in std_logic_vector (7 downto 0);
    start : in std_logic;
    timer : in std_logic;
    oneW_out : out std_logic;
    cond_tri_state : out std_logic;
    write_8b_done : out std_logic);
end component;

signal s_timer : std_logic;

signal s_cmd_init : std_logic;
signal s_init_done : std_logic;
signal s_start_read : std_logic;
signal s_write_8b_done : std_logic;
signal s_read_8b_done : std_logic;
signal s_start_write : std_logic;
signal s_word_read : std_logic_vector(7 downto 0);
signal s_word_write : std_logic_vector(7 downto 0); 
signal oneW_out_init : std_logic;
signal oneW_out_read : std_logic;
signal oneW_out_write : std_logic;
signal cond_tri_state_init : std_logic;
signal cond_tri_state_read : std_logic;
signal cond_tri_state_write : std_logic;

begin 

U_protocole_init : protocole_init
port map(
cmd_init => s_cmd_init,
rst => rst,
timer => timer,
clk => clk,
oneW_in => oneW_synchro,
oneW_out => oneW_out_init,
cond_tri_state => cond_tri_state_init,
init_done => s_init_done);

U_master_protocol : master_protocole 
port map(clk => clk,
      rst => rst,
      init_done => s_init_done,
      write_8b_done => s_write_8b_done,
      read_8b_done => s_read_8b_done,
      start_protocole => start_protocol,
      timer => timer,
      oneW_in => oneW_synchro,
      word_read => s_word_read,
      temp => temp,      
      ready => ready,
      cmd_init => s_cmd_init,
      start_read => s_start_read,
      start_write => s_start_write,     
      word_write => s_word_write);

U_read_8b : read_8b
port map(
    rst => rst,
    clk => clk,
    msg_read => s_word_read,	
    start => s_start_read,
    timer => timer,
    oneW_out => oneW_out_read,
	oneW_in => oneW_synchro,
    cond_tri_state => cond_tri_state_read,
    read_8b_done => s_read_8b_done);

U_write_8b : write_8b 
port map(
    rst => rst,
    clk => clk,
    word => s_word_write,
    start => s_start_write,
    timer => timer,
    oneW_out => oneW_out_write,
    cond_tri_state  => cond_tri_state_write,
    write_8b_done => s_write_8b_done);


-- Condition or pour qu'un seul des blocs gère la sortie
oneW_out <= oneW_out_write or oneW_out_read or oneW_out_init;
cond_tri_state <= cond_tri_state_write or cond_tri_state_read or cond_tri_state_init;
end Behavioral;
