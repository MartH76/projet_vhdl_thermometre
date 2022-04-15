
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity recup_dizaine is
   Port (
   clk: in std_logic;
   rst: in std_logic;
   freq: in std_logic_vector(37 downto 0);
   virgule: in std_logic_vector(4 downto 0);
   unit: out std_logic_vector(3 downto 0);
   dizaine: out std_logic_vector(3 downto 0);
   centaine: out std_logic_vector(3 downto 0);
   millier: out std_logic_vector(3 downto 0);
   d_millier: out std_logic_vector(3 downto 0);
   c_millier: out std_logic_vector(3 downto 0);
   decimal: out std_logic_vector(3 downto 0);
   repere: out std_logic_vector(2 downto 0)
   );
end recup_dizaine;

architecture Behavioral of recup_dizaine is

type etat is (reset,init,cmille,dmille,mille,cent,diz,un,sous_u,sous_d,sous_c,sous_m,sous_dm,sous_cm,fini,virg,sous_virg,e1,e2,e3,e4);
signal etatp: etat;
signal u,d,c,m,dm,cm,v: unsigned(3 downto 0);
signal f: integer range 0 to 500000;
signal calc_v: integer range 0 to 900000;
signal s_repere: unsigned(2 downto 0);
signal f_v: std_logic_vector(10 downto 0);

begin

process(rst,clk)
begin
    
end process;

process(clk,rst)
begin
    if rst='1' then
        etatp<=reset;
    elsif rising_edge(clk) then
        case etatp is
            when reset =>
                etatp<=init;
            when init =>
                f<=to_integer(unsigned(freq(37 downto 11)));
                f_v<=freq(10 downto 0);
                u<="0000";
                d<="0000";
                c<="0000";
                m<="0000";
                dm<="0000";
                cm<="0000";
                v<="0000";
                calc_v<=0;
                s_repere<="000";
                etatp<= cmille;
                
            when cmille =>
                if (f>=100000) then
                    etatp<=sous_cm;
                else 
                    etatp<=dmille;
                end if;
            when sous_cm =>
                f<=f-100000;
                cm<=cm+1;
                s_repere(2)<='1';
                etatp<=cmille;
                
            when dmille =>
                if (f>=10000) then
                    etatp<=sous_dm;
                else 
                    etatp<=mille;
                end if;
            when sous_dm =>
                f<=f-10000;
                dm<=dm+1;
                s_repere(1)<='1';
                etatp<=dmille;
                
            when mille =>
                if (f>=1000) then
                    etatp<=sous_m;
                else 
                    etatp<=cent;
                end if;
            when sous_m =>
                f<=f-1000;
                m<=m+1;
                s_repere(0)<='1';
                etatp<=mille;
                
            when cent =>
                if (f>=100) then
                    etatp<=sous_c;
                else 
                    etatp<=diz;
                end if;
            when sous_c =>
                f<=f-100;
                c<=c+1;
                etatp<=cent;
            
            when diz =>
                if (f>=10) then
                    etatp<=sous_d;
                else 
                    etatp<=un;
                end if;
            when sous_d =>
                f<=f-10;
                d<=d+1;
                etatp<=diz;
            
            when un =>
                if (f>=1) then
                    etatp<=sous_u;
                else 
                    etatp<=e1;
                end if;
            when sous_u =>
                f<=f-1;
                u<=u+1;
                etatp<=un;
                
        --    when inter =>
        --         unit<=std_logic_vector(u);
        --         dizaine<=std_logic_vector(d);
        --         centaine<=std_logic_vector(c);
        --         millier<=std_logic_vector(m);
        --         d_millier<=std_logic_vector(dm);
        --         c_millier<=std_logic_vector(cm);
        --         etatf<=e1;
                 
            when e1=>
                if freq(10)='1' then
                    calc_v<=calc_v+5000;
                 end if;
                 etatp<=e2;
                 
            when e2=>
                if freq(9)='1' then
                    calc_v<=calc_v+2500;
                 end if;
                 etatp<=e3;
                 
            when e3 =>
                if freq(8)='1' then
                    calc_v<=calc_v+1250;
                 end if;
                 etatp<=e4;
                 
            when e4 =>
                 if freq(7)='1' then
                    calc_v<=calc_v+625;
                 end if;
                 etatp<=virg;
                 
            when virg =>
                if (calc_v>1000) then
                    etatp<=sous_virg;
                else 
                    etatp<=fini;
                end if; 
            when sous_virg =>
                calc_v<=calc_v-1000;
                v<=v+1;
                etatp<=virg;
            when fini =>
                unit<=std_logic_vector(u);
                dizaine<=std_logic_vector(d);
                centaine<=std_logic_vector(c);
                millier<=std_logic_vector(m);
                d_millier<=std_logic_vector(dm);
                c_millier<=std_logic_vector(cm);
                decimal<=std_logic_vector(v);
                repere<=std_logic_vector(s_repere);
                etatp<=init;
            end case;
    end if;
end process;

end Behavioral;
