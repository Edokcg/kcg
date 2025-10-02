--メタル·リフレクト·スライム
local s, id = GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={10000000,10000020,1000001,42166000,1439,1440}

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetAttacker()~=nil and Duel.GetAttacker():IsControler(1-tp)
	and Duel.GetAttacker():GetLevel()>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetAttacker()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,0,g:GetDefense()*3/4,10,RACE_AQUA,ATTRIBUTE_WATER|g:GetOriginalAttribute(),POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetAttacker()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,0,g:GetDefense()*3/4,10,RACE_AQUA,ATTRIBUTE_WATER|g:GetOriginalAttribute(),POS_FACEUP_DEFENSE) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	c:AddMonsterAttributeComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_DEFENSE)
	e1:SetValue(g:GetAttack()*3/4)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(g:GetOriginalAttribute())
	c:RegisterEffect(e2)
	if g:IsCode(10000000) then c:CopyEffect(42166000,RESET_EVENT+RESETS_STANDARD_DISABLE,1) c:SetCardData(CARDDATA_PICCODE,42166000,0,RESET_EVENT+RESETS_STANDARD_DISABLE,c) end
	if g:IsCode(10000020) then c:CopyEffect(1439,RESET_EVENT+RESETS_STANDARD_DISABLE,1) c:SetCardData(CARDDATA_PICCODE,1439,0,RESET_EVENT+RESETS_STANDARD_DISABLE,c) end
	if g:IsCode(10000010) then c:CopyEffect(1440,RESET_EVENT+RESETS_STANDARD_DISABLE,1) c:SetCardData(CARDDATA_PICCODE,1440,0,RESET_EVENT+RESETS_STANDARD_DISABLE,c) end
	Duel.SpecialSummonComplete()
end