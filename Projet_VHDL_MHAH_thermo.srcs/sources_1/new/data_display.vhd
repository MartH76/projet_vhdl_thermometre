----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2022 09:07:37
-- Design Name: 
-- Module Name: data_display - Behavioral
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

entity data_display is
Port ( 
clk : in std_logic;
rst : in std_logic;
timer : in std_logic;
ready : in std_logic;
temp : in std_logic_vector(15 downto 0);
AN : out std_logic_vector(7 downto 0);
dp_int : out std_logic;
BCD : out std_logic_vector(6 downto 0));
end data_display;

architecture Behavioral of data_display is

component temp_buffer is
  Port (
    temperature : in std_logic_vector(15 downto 0);
    ready : in std_logic;
    clk : in std_logic;
    temp_buff : out std_logic_vector(15 downto 0));
end component;

component NegToPos is
Port ( 
    temp_buff : in std_logic_vector(15 downto 0);
    sign : out std_logic;
    virgule : out std_logic;
    clk : in std_logic;
    rst : in std_logic;
    temp_8b : out std_logic_vector(7 downto 0));
end component;

component puissance_10 is
Port (
    clk         : in std_logic;
    temperature  : in std_logic_vector(7 downto 0);
    centaine       : out std_logic_vector (3 downto 0);
    dizaine         : out std_logic_vector (3 downto 0);
    unite          : out std_logic_vector (3 downto 0);
    rst      : in std_logic);
end component;

component segment7 is
Port (
      unit              : in std_logic_vector(3 downto 0);
      ten               : in std_logic_vector(3 downto 0); 
      hundred           : in std_logic_vector(3 downto 0);  
      virgule           : in std_logic;   
      sign              : in std_logic;  
      timer             : in std_logic;   
      AN_out            : out std_logic_vector(7 downto 0);  
      BCD               : out std_logic_vector(6 downto 0);
      clk               : in std_logic;
      rst               : in std_logic;
      dp_int            : out std_logic);
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

signal s_virgule : std_logic;
signal s_sign : std_logic;
signal s_temp_8b : std_logic_vector(7 downto 0);
signal s_unit : std_logic_vector(3 downto 0);
signal s_ten : std_logic_vector(3 downto 0);
signal s_hundred : std_logic_vector(3 downto 0);
signal s_temperature : std_logic_vector(15 downto 0);
signal s_cpt_1m_end : std_logic;
begin

U_temp_buffer : temp_buffer 
 port map(
    temperature => temp,
    ready => ready,
    clk => clk,
    temp_buff => s_temperature);

U_NegToPos : NegToPos 
port map( 
    temp_buff => s_temperature,
    sign => s_sign,
    virgule => s_virgule,
    clk => clk,
    rst => rst,
    temp_8b => s_temp_8b);

U_puissance_10 : puissance_10
port map(
    clk => clk,
    temperature => s_temp_8b,
    centaine => s_hundred,
    dizaine => s_ten,
    unite => s_unit,
    rst => rst);

U_segment7 : segment7 
port map(
      unit => s_unit,
      ten => s_ten,
      hundred => s_hundred,
      virgule => s_virgule,
      sign => s_sign,
      timer => s_cpt_1m_end,
      AN_out => AN,
      rst => rst,
      BCD => BCD,
      clk => clk,
      dp_int => dp_int);



U_compteur_15u : compteur
generic map(FIN_COMPTEUR => 1000)
port map(
clk => clk,
rst => rst,
timer => timer,
start_compteur => '1',
compteur_end => s_cpt_1m_end);

end Behavioral;
