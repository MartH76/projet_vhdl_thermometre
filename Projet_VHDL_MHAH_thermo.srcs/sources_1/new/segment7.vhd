----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.10.2021 17:29:11
-- Design Name: 
-- Module Name: Display_Module - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity segment7 is
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
end segment7;

architecture Behavioral of segment7 is


component AN_counter is
port(
    rst : in std_logic;
    clk : in std_logic;
    timer : in std_logic;
    AN : out std_logic_vector(7 downto 0));
end component;

component Data_ctrler is
Port (unit              : in std_logic_vector(3 downto 0);
      ten               : in std_logic_vector(3 downto 0);
      hundred           : in std_logic_vector(3 downto 0);
      virgule           : in std_logic;
      signe             : in std_logic;
      clk               : in std_logic;
      rst               : in std_logic;
      AN                : in std_logic_vector(7 downto 0);
      data              : out std_logic_vector(3 downto 0);
      dp_int            : out std_logic);
      
end component;

component BCD_decoder is
port(
      display         : out std_logic_vector(6 downto 0);   
      rst               : in std_logic;
      clk               : in std_logic; 
      data        : in std_logic_vector(3 downto 0));  
end component;


signal AN_int : std_logic_vector(7 downto 0);
signal data : std_logic_vector(3 downto 0);
signal s_Hz : std_logic;

begin

U_BCD_decoder : BCD_decoder
port map(
data => data,
display => BCD,
clk => clk,
rst => rst
);

U_data_ctrler : data_ctrler
port map(
    data=> data,
    unit => unit,
    ten => ten,
    clk => clk,
    rst => rst,
    hundred => hundred,
    virgule => virgule,
    signe => sign,
    AN => AN_int,
    dp_int => dp_int);

U_AN_counter : AN_counter 
port map(
    rst => rst,
    clk => clk,
    timer => timer,
    AN => AN_int);

AN_out <= AN_int;

end Behavioral;
