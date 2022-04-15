----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2022 09:25:05
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
Port ( 
    clk : in std_logic;
    rst : in std_logic;
    oneW : inout std_logic;
    AN : out std_logic_vector(7 downto 0);
    dp_int : out std_logic;
    global_start : in std_logic;
    BCD : out std_logic_vector(6 downto 0));
end top_level;

architecture Behavioral of top_level is

component resynchro is
port( 
    clk : in std_logic;
    oneW_in : in std_logic;
    oneW_synchro : out std_logic);
end component;

component data_display is
Port ( 
    clk : in std_logic;
    rst : in std_logic;
    timer : in std_logic;
    ready : in std_logic;
    temp : in std_logic_vector(15 downto 0);
    AN : out std_logic_vector(7 downto 0);
    dp_int : out std_logic;
    BCD : out std_logic_vector(6 downto 0));
end component; 

component protocol is
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

component timer is
Port ( 
    clk : in std_logic;
    rst : in std_logic;
    timer_out : out std_logic);
end component;

component compteur is
generic(FIN_COMPTEUR : integer);
Port ( 
clk : in std_logic;
rst : in std_logic;
timer : in std_logic;
start_compteur : in std_logic;
compteur_end : out std_logic);
end component;

signal s_oneW_synchro : std_logic;
signal s_temp : std_logic_vector(15 downto 0);
signal s_ready : std_logic;
signal s_timer : std_logic;
signal s_cond_tri_state : std_logic;
signal s_oneW_out : std_logic;
signal s_timer_1s : std_logic;




begin


U_resynchro : resynchro 
port map(
    clk => clk,
    oneW_in => oneW,
    oneW_synchro => s_oneW_synchro);

U_compteur_1s : compteur
generic map(FIN_COMPTEUR => 1000000)
port map(
clk => clk,
rst => rst,
timer => s_timer,
start_compteur => global_start,
compteur_end => s_timer_1s);

U_data_display : data_display
port map(
    clk => clk,
    rst => rst,
    timer => s_timer,
    ready => s_ready,    
    temp => s_temp,
    AN => AN,
    dp_int => dp_int,
    BCD => BCD);

U_protocol : protocol
port map(
    clk => clk,
    rst => rst,
    start_protocol => s_timer_1s,
    oneW_synchro => s_oneW_synchro,
    timer => s_timer,
    oneW_out => s_oneW_out,
    ready =>  s_ready,
    cond_tri_state => s_cond_tri_state,
    temp => s_temp);

U_timer : timer
port map(
    clk => clk,
    rst => rst,
    timer_out => s_timer);
    
oneW <= s_oneW_out when (s_cond_tri_state = '1') else 'Z'; -- oneW sort si cond tri state = 1 sonon etat Z

end Behavioral;
