--绿眼纳祭神（neet）
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
--Equip 
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_EQUIP)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e10:SetCountLimit(1,id)
	e10:SetCondition(s.eqcon)
	e10:SetTarget(s.eqtg)
	e10:SetOperation(s.eqop)
	c:RegisterEffect(e10)
	aux.AddEREquipLimit(c,nil,s.eqop,s.equipop,e10)
--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	-- def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(s.defval)
	c:RegisterEffect(e3)
end
s.listed_series={0x110}
s.listed_names={78063197}
function s.thfilter(c)
	return c:IsCode(78063197) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		s.equipop(c,e,tp,tc)
	end
end
function s.equipop(c,e,tp,tc)
	c:EquipByEffectAndLimitRegister(e,tp,tc,id)
end
function s.atkfilter(c)
	return c:GetFlagEffect(id)~=0 
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(s.atkfilter,nil)
	return #g>0
end
function s.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(id)~=0 and tc:IsFaceup() and tc:GetAttack()>=0 then
			atk=atk+tc:GetAttack()
		end
	end
	return atk
end
function s.defval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(id)~=0 and tc:IsFaceup() and tc:GetDefense()>=0 then
			atk=atk+tc:GetDefense()
		end
	end
	return atk
end
