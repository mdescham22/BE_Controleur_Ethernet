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

entity Emetteur is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           TABORTP : in STD_LOGIC;
           TAVAILP : in STD_LOGIC;
           TDATAI : in STD_LOGIC_VECTOR (7 downto 0);
           TDATAO : out STD_LOGIC_VECTOR (7 downto 0);
           TDONEP : out STD_LOGIC;
           TFINISHP : in STD_LOGIC;
           TLASTP : in STD_LOGIC;
           TREADDP : out STD_LOGIC;
           TRNSMTP : out STD_LOGIC;
           TSTARTP : out STD_LOGIC);
end Emetteur;

architecture Behavioral of Emetteur is

    signal AUX_TRNSMTP: STD_LOGIC;
    signal AUX_TDONEP: STD_LOGIC;
    signal SFD: STD_LOGIC_VECTOR (7 downto 0)       := "10101011";
    signal EFD: STD_LOGIC_VECTOR (7 downto 0)       := "01010100";
    signal ADDR: STD_LOGIC_VECTOR (47 downto 0)     := X"ABCDEF102397";
    signal cpt_wait: STD_LOGIC_VECTOR (2 downto 0)  := "000";
    signal cpt_trame: integer range 5 downto 0      := 0;
    signal cpt_etape: STD_LOGIC_VECTOR (2 downto 0) := "000";
    
begin

    TRNSMTP <=  AUX_TRNSMTP;
    TDONEP  <=  AUX_TDONEP;

Main : process

begin
    
    wait until CLK'Event and CLK='1';
    
    if (RESET = '0') then
        TREADDP     <=  '0';
        TDATAO      <=  "00000000";
        TSTARTP     <=  '0';
        AUX_TRNSMTP <=  '0';
        AUX_TDONEP  <=  '0';
        cpt_wait    <=  "000";
        cpt_trame   <=  0;
        cpt_etape   <=  "000";
    
    elsif (TABORTP='1' or TFINISHP='1') then
        AUX_TDONEP <= '1';
       
    elsif (AUX_TDONEP = '1') then
        TREADDP     <=  '0';
        TDATAO      <=  "00000000";
        TSTARTP     <=  '0';
        AUX_TRNSMTP <=  '0';
        AUX_TDONEP  <=  '0';
        cpt_wait    <=  "000";
        cpt_trame   <=  0;
        cpt_etape   <=  "000";
   
    elsif (TAVAILP='1' and AUX_TDONEP='0' and AUX_TRNSMTP = '0') then
        TSTARTP <= '1';
        AUX_TRNSMTP <='1';
    
    elsif (AUX_TRNSMTP = '1' and AUX_TDONEP = '0') then
        if (cpt_wait="00") then
                
            if(cpt_etape="000") then -- trame addr SFD
               TSTARTP <= '0';
               TDATAO <= SFD;
               cpt_etape <= "001";
               cpt_trame <= 5;
            
            elsif (cpt_etape="001") then -- trame addr destination
               TREADDP <= '1';
               TDATAO <= TDATAI;
               if (cpt_trame = 0) then
                    cpt_etape <= "010";
                    cpt_trame <= 5;
               else
                cpt_trame <= cpt_trame-1;
               end if;
                
            elsif(cpt_etape="010") then -- trame addr source
                TREADDP <= '0';
                TDATAO <= ADDR((7+cpt_trame*8) downto (cpt_trame*8)); 
                if (cpt_trame = 0) then
                    cpt_etape <= "011";
                    cpt_trame <= 0;
                else
                    cpt_trame <= cpt_trame-1;    
                end if; 
                
            elsif(cpt_etape="011") then -- trame addr donnée
                if (TLASTP='0') then 
                    TREADDP <= '1';
                    TDATAO <= TDATAI;
                else
                    TREADDP <= '0';
                    TDATAO <= EFD;
                    cpt_etape <= "100";
                end if;    
           
            elsif(cpt_etape="100") then -- trame addr fin
                    AUX_TDONEP <= '1';         
            end if;
           
        else
            TREADDP <= '0';
        
        end if;
        cpt_wait<=cpt_wait+1;
    
    end if;
    
end process;

end Behavioral;
