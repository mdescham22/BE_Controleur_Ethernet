----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2022 17:19:03
-- Design Name: 
-- Module Name: Controleur_Ethernet - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Controleur_Ethernet is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           TABORTP : in STD_LOGIC;
           TAVAILP : in STD_LOGIC;
           TDATAI : in STD_LOGIC_VECTOR (7 downto 0);
           TDATAO : out STD_LOGIC_VECTOR (7 downto 0);
           TDONEP : out STD_LOGIC;
           TFINISHP : in STD_LOGIC;
           TLASTP : in STD_LOGIC;
           TREADP : out STD_LOGIC;
           TRNSMTP : out STD_LOGIC;
           TSTARTP : out STD_LOGIC);
end Controleur_Ethernet;

architecture Behavioral of Controleur_Ethernet is

    signal AUX: STD_LOGIC;
    signal SFD: STD_LOGIC_VECTOR (7 downto 0);
    signal ADDR: STD_LOGIC_VECTOR (47 downto 0);
    signal cpt_clk: STD_LOGIC_VECTOR (3 downto 0);
    signal cpt: STD_LOGIC_VECTOR (5 downto 0);
begin

process

begin
    TRNSMTP<=AUX;
    wait until CLK'Event and CLK='1';
    if (TAVAILP='1') then
        TSTARTP <= '1';
        TRNSMTP <='1';
        TDATAO <= SFD;
        if (AUX<='1') then
            if (cpt_clk="0") then
                if (cpt>="0" and cpt<6) then
                    TDATAO <= TDATAI;
                    cpt<=cpt+1;
                elsif(cpt>=6 and cpt<12) then
                    TDATAO <= ADDR;
                end if;
                cpt_clk<=cpt_clk+1;
                
            elsif(cpt_clk = "111") then cpt_clk<="0";
            else cpt_clk<=cpt_clk+1;
            
            end if;
         
        
        end if;
    end if;
    
    
end process;

end Behavioral;
