-- Multiply (Anime)
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsAttackBelow(500) and c:IsFaceup()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0,c:GetType()|TYPE_TOKEN,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute()) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 or not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	local ct=0
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or ft==1 then ct=1
	else
		local nums = {}
		for i=1,ft do
			table.insert(nums, i)
		end
		ct=Duel.AnnounceNumber(tp,table.unpack(nums))
	end
	local g=Group.CreateGroup()
	for i=1,ct do
        local sc=Duel.CreateToken(tp,tc:GetOriginalCode())
		g:AddCard(sc)
	end
    for sc in aux.Next(g) do
        if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,tc:GetPosition()) then
            sc:SetCardData(CARDDATA_TYPE,sc:GetOriginalType()|TYPE_TOKEN)
        end
    end
    Duel.SpecialSummonComplete()
end