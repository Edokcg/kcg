--No.75 惑乱のゴシップ・シャドー
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_SPELLCASTER),4,3,nil,nil,7)

	--battle indestructable
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--Change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.chcon)
	e1:SetCost(s.chcost)
	e1:SetTarget(s.chtg)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)

	--Attach a card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.xtg)
	e2:SetOperation(s.xop)
	c:RegisterEffect(e2)
end
s.listed_names={71166481}
s.listed_series={0x48}
s.xyz_number=75

function s.indes(e,c)
	return not c:IsSetCard(0x48)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,71166481) and Duel.IsPlayerCanDraw(1-tp,2) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
	Duel.Draw(1-tp,2,REASON_EFFECT)
	else Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function s.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function s.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(s.xfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.xfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function s.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local mg=c:GetOverlayGroup()
		if #mg>0 then Duel.Overlay(tc,mg) end
		Duel.Overlay(tc,c)
	end
end