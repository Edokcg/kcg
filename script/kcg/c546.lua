--死の宣告
--Sentence of Doom
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	--place on the field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(CARD_DESTINY_BOARD)
	e3:SetCost(s.plcost)
	e3:SetTarget(s.pltg)
	e3:SetOperation(s.plop)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_DESTINY_BOARD}
s.listed_series={SET_SPIRIT_MESSAGE}

function s.filter(c)
	return c:IsFaceup() and (c:IsCode(CARD_DESTINY_BOARD) or c:IsSetCard(SET_SPIRIT_MESSAGE))
end
function s.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsMonster() and c:IsAbleToHand()
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE|LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc) end
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

function s.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 end
end
function s.cfilter3(c)
	return c:IsFaceup() and c:IsCode(table.unpack(CARDS_SPIRIT_MESSAGE))
end
function s.plfilter(c,code)
	return c:IsCode(code) and not c:IsForbidden() and c:IsFaceup()
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter3,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or g:GetClassCount(Card.GetCode)>3 then return end
	local passcode1=CARDS_SPIRIT_MESSAGE[1]
	local passcode2=CARDS_SPIRIT_MESSAGE[2]
	local passcode3=CARDS_SPIRIT_MESSAGE[3]
	local passcode4=CARDS_SPIRIT_MESSAGE[4]
	local off=1
	local ops={}
	local opval={}
	if not Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_ONFIELD,0,1,nil,passcode1) then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=1
		off=off+1
	end
	if not Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_ONFIELD,0,1,nil,passcode2) then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=2
		off=off+1
	end
	if not Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_ONFIELD,0,1,nil,passcode3) then
		ops[off]=aux.Stringid(id,4)
		opval[off-1]=3
		off=off+1
	end
	if not Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_ONFIELD,0,1,nil,passcode4) then
		ops[off]=aux.Stringid(id,5)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local token=Duel.CreateToken(tp,passcode1)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif opval[op]==2 then
		local token=Duel.CreateToken(tp,passcode2)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif opval[op]==3 then
		local token=Duel.CreateToken(tp,passcode3)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif opval[op]==4 then
		local token=Duel.CreateToken(tp,passcode4)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end