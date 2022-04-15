library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_global_BCD is
Port (
    unit            : in std_logic_vector(3 downto 0);
    ten             : in std_logic_vector(3 downto 0);
    hundred         : in std_logic_vector(3 downto 0);
    thousand        : in std_logic_vector(3 downto 0);
    ten_thousand    : in std_logic_vector(3 downto 0);
    hundred_thousand: in std_logic_vector(3 downto 0);
    million         : in std_logic_vector(3 downto 0);
    ten_million     : in std_logic_vector(3 downto 0);
    dp_vector       : in std_logic_vector(7 downto 0);
    rst: in std_logic;
    clk: in std_logic;
    DP: out std_logic;
    AN_out: out std_logic_vector(7 downto 0);
    BCD: out std_logic_vector(6 downto 0)
     );
end control_global_BCD;

architecture Behavioral of control_global_BCD is

component data_control
    port (
    unit            : in std_logic_vector(3 downto 0);
    ten             : in std_logic_vector(3 downto 0);
    hundred         : in std_logic_vector(3 downto 0);
    thousand        : in std_logic_vector(3 downto 0);
    ten_thousand    : in std_logic_vector(3 downto 0);
    hundred_thousand: in std_logic_vector(3 downto 0);
    million         : in std_logic_vector(3 downto 0);
    ten_million     : in std_logic_vector(3 downto 0);
    dp_vector       : in std_logic_vector(7 downto 0);
    AN              : in std_logic_vector(7 downto 0);
    data            : out std_logic_vector(3 downto 0);
    DP              : out std_logic
    );
end component;

component BCD_7_segments
Port (
    data : in std_logic_vector(3 downto 0);
    BCD : out std_logic_vector(6 downto 0));
end component;

component clk_divider_1kHz
    port (
    clk: in std_logic;
    rst: in std_logic;
    clk_1kHz: out std_logic
    );
end component;

component AN_counter
    Port (
    clk: in std_logic;
    rst: in std_logic;
    clk_1kHz: in std_logic;
    AN: out std_logic_vector(7 downto 0));
end component;


signal AN_temp: std_logic_vector(7 downto 0);
signal data_temp: std_logic_vector(3 downto 0);
signal clk_1kHz_temp: std_logic;

begin

data_control_1: data_control port map(
unit=>unit,
ten=>ten,
hundred=>hundred,
thousand=>thousand,
ten_thousand=>ten_thousand,
hundred_thousand=>hundred_thousand,
million=>million,
ten_million=>ten_million,
dp_vector=>dp_vector,
AN=>AN_temp,
data=>data_temp,
DP=>DP
);

BCD_7_segments_1: BCD_7_segments port map(
data=>data_temp,
BCD=>BCD
);

clk_divider_1: clk_divider_1kHz port map(
clk=>clk,
rst=>rst,
clk_1kHz=>clk_1kHz_temp
);

AN_counter_1: AN_counter port map(
clk=>clk,
rst=>rst,
clk_1kHz=>clk_1kHz_temp,
AN=>AN_temp
);

AN_out<=AN_temp;

end Behavioral;
