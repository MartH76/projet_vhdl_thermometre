----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2022 08:11:29
-- Design Name: 
-- Module Name: write_8b - Behavioral
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

entity read_8b is
Port (
    rst : in std_logic;
    clk : in std_logic;
    msg_read : out std_logic_vector (7 downto 0); --sortie avec message lu
    start : in std_logic; --signal pour demarrer le lecture
    timer : in std_logic; -- timer_1u
    oneW_out : out std_logic;
	oneW_in : in std_logic;	
    cond_tri_state : out std_logic;	
    read_8b_done : out std_logic); --signal pour indiquer la fin de l'init
end read_8b;

architecture Behavioral of read_8b is

type state is (INIT, BUFFER_INIT, START_READ_1B ,MASTER_RELEASE, MASTER_RELEASE_WAIT , READ_BIT, READ_0, READ_1, END_READ_1B, END_READ, END_STATE);

signal current_state : state ;

signal s_msg_read : std_logic_vector(7 downto 0);

signal nbr_bit_lu : integer;
signal nbr_bit_lu_buff : integer;
signal start_cpt_15u : std_logic;
signal cpt_15u_end : std_logic;

signal start_cpt_45u : std_logic;
signal cpt_45u_end : std_logic;

component compteur is
generic(FIN_COMPTEUR : integer);
Port ( 
	clk : in std_logic;
	rst : in std_logic;
	timer : in std_logic;
	start_compteur : in std_logic;
	compteur_end : out std_logic);
end component;


begin

U_compteur_15u : compteur
generic map(FIN_COMPTEUR => 15)
port map(
clk => clk,
rst => rst,
timer => timer,
start_compteur => start_cpt_15u,
compteur_end => cpt_15u_end);


U_compteur_45u : compteur
generic map(FIN_COMPTEUR => 45)
port map(
clk => clk,
rst => rst,
timer => timer,
start_compteur => start_cpt_45u,
compteur_end => cpt_45u_end);


process(rst, clk) is
begin
     if rst='1' then
          current_state <= INIT;
          read_8b_done <= '0';
          cond_tri_state <= '0';
     elsif rising_edge(clk) then
          case current_state is
               when INIT =>  read_8b_done <= '0'; --on reste dans l'init en attendant le start qui vient du master protocole
                             cond_tri_state <= '0';
                             nbr_bit_lu <= 0;
                             oneW_out <= '0';
                             s_msg_read <= "00000000";
                          if start='1' then --start
                               cond_tri_state <= '1'; --on prend l main sur le one wire
                               oneW_out <= '0'; -- pull down pour demarrer une lecture
                               current_state <= BUFFER_INIT;
                          end if;
                when BUFFER_INIT => if timer = '1' then -- pull down for 1us
											current_state <= START_READ_1B;
									end if;	  
                when START_READ_1B => if timer = '1' then 
                                            nbr_bit_lu_buff <= nbr_bit_lu;
											current_state <= MASTER_RELEASE;
									end if;
						   
                when MASTER_RELEASE =>  cond_tri_state <= '0';              
                                      start_cpt_15u <= '1'; --on demarre les deux compteurs
									  start_cpt_45u <= '1';
                                      current_state <= MASTER_RELEASE_WAIT;
                when MASTER_RELEASE_WAIT => if cpt_15u_end = '1' then --après 15us on regarde l'état du one Wire
										current_state <= READ_BIT;
										end if;
				when READ_BIT => if oneW_in = '0' then --si 0 on lit 0 sinon on lit un 1
									current_state <= READ_0;
								 else if oneW_in = '1' then
									current_state <= READ_1;
							     end if;
							     end if;
				when READ_0 => if cpt_45u_end = '1' then --on attend les 45us pour etre sur que la ligne soit relachée
									start_cpt_15u <= '0';
									s_msg_read <= "0" & s_msg_read(7 downto 1);
									start_cpt_45u <= '0';
									current_state <= END_READ_1B;
									end if;
				when READ_1 => if cpt_45u_end = '1' then --on attend les 45us pour etre sur que la ligne soit relachée
									start_cpt_15u <= '0';
									s_msg_read <= "1" & s_msg_read(7 downto 1);
									start_cpt_45u <= '0';
									current_state <= END_READ_1B;
								end if;
				when END_READ_1B => nbr_bit_lu <= nbr_bit_lu_buff + 1; --on incrémente la variable qui stocke le nombre de bits lus
									if nbr_bit_lu = 8 then --si on en a lu 8 on a finit la lecture
										current_state <= END_READ;
									else if nbr_bit_lu < 8 and timer = '1' then --sinon on va relire un bit
										current_state <= START_READ_1B;
										cond_tri_state <= '1';
										oneW_out <= '0';
								    end if;
								    end if;
				when END_READ => read_8b_done <= '1';	--on renvoie un done pour dire qu'on à finit
				            current_state <= END_STATE;			    
				when END_STATE => read_8b_done <= '0';   --on se positionne pour pouvoir relancer une lecture et on sort le byte lu
							msg_read <= s_msg_read;
							current_state <= INIT;
                when others => current_state <= INIT;                      
                end case;
     end if;
end process;

end Behavioral;
