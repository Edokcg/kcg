--覇王門零
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e0:SetTargetRange(1,0)
	e0:SetCondition(s.splimcon)
	e0:SetTarget(s.splimit)
	c:RegisterEffect(e0)
	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(0)
	e1:SetCondition(s.damcon)
	e1:SetValue(s.damval)
	c:RegisterEffect(e1)
	--copy	
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_PZONE)
	e2:SetLabelObject(e1)
	e2:SetOperation(s.trig)
	c:RegisterEffect(e2)
	--Add 1 "Polymerization" spell or "fusion" spell from deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.pcon)
	e3:SetTarget(s.ptg)
	e3:SetOperation(s.pop)
	c:RegisterEffect(e3)
	--Special summon 1 dragon fusion or synchro monster from extra deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end
s.listed_series={0xf8,0x46}
s.listed_names={22211622}

function s.splimcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>0
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf8)
end
function s.damcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if val~=0 then
		e:SetLabel(val)
		return 0
	else return val end
end

function s.trig(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabelObject():GetLabel()
	if val~=0 then
		Duel.RaiseEvent(e:GetHandler(),96227613,e,REASON_EFFECT,tp,tp,val)
		e:GetLabelObject():SetLabel(0)
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),22211622)
end
function s.thfilter(c)
	return c:IsSpell() and c:IsSetCard(0x46) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if #g<2 then return end
	if Duel.Destroy(g,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

function s.pcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pfilter(c)
	return c:IsCode(22211622) and c:IsAbleToHand()
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.desfilter(c,e,tp,mc)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c,mc))-- and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function s.spfilter(c,e,tp,mg)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and s.desfilter(chkc,e,tp,c) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,0,1,c,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_ONFIELD,0,1,1,c,e,tp,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) then return end
	local dg=Group.FromCards(c,tc)
	if Duel.Destroy(dg,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g==0 then return end
		local sc=g:GetFirst()
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
			--Negate its effects
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2,true)
			--ATK/DEF becomes 0
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
			sc:RegisterEffect(e4,true)
			--Cannot be used as synchro material
			-- local e5=e3:Clone()
			-- e5:SetDescription(3310)
			-- e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			-- e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			-- e5:SetValue(1)
			-- sc:RegisterEffect(e5,true)
			-- --Cannot be used as Xyz material
			-- local e6=e5:Clone()
			-- e6:SetDescription(3311)
			-- e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			-- sc:RegisterEffect(e6,true)
		end
		Duel.SpecialSummonComplete()
	end
end