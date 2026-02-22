local s,id=GetID()
function s.initial_effect(c)
	local e4=Effect.GlobalEffect()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_EQUIP)
	e4:SetOperation(s.op4)
	Duel.RegisterEffect(e4,0)

	--Add to hand or Special Summon 3 "Meklord" monsters with different names in your GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	e1:SetLabelObject(e4)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_MEKLORD,SET_MEKLORD_ASTRO}

function s.eqfilter(c)
	local ec=c:GetEquipTarget()
	return c:IsMonsterCard() and ec and ec:IsSetCard(SET_MEKLORD)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.eqfilter,nil)
	local count=e:GetLabel()+#g
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,RESET_PHASE|PHASE_END,0,1)
	end
	e:SetLabel(count)
end

function s.eqedfilter(c)
	return c:IsMonster() and c:GetFlagEffect(id)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
		and Duel.IsExistingMatchingCard(s.eqedfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(s.eqedfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
	local te=e:GetLabelObject()
	if not te then return end
	local val=te:GetLabel()
	if not val then return end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,(val+#g)*600)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_MEKLORD)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqg=Duel.SelectMatchingCard(tp,s.eqedfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,99,nil)
	if #eqg<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g<1 then return end
	local tc2=g:GetFirst()
	local count=0
	if tc2:IsFaceup() then
		for tc in aux.Next(eqg) do
			if not Duel.Equip(tp,tc,tc2,false) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(s.eqlimit)
			e1:SetLabelObject(tc2)
			tc:RegisterEffect(e1)
			count=count+1
		end
	end
	Duel.BreakEffect()
	local te=e:GetLabelObject()
	if not te then Duel.Damage(1-tp,count*600,REASON_EFFECT) Duel.Recover(tp,600,REASON_EFFECT) return end
	local val=te:GetLabel()
	if not val then Duel.Damage(1-tp,count*600,REASON_EFFECT) Duel.Recover(tp,600,REASON_EFFECT) return end
	Duel.Damage(1-tp,val*600,REASON_EFFECT)
	Duel.Recover(tp,600,REASON_EFFECT)
end
function s.eqlimit(e,c)
	local tc2=e:GetLabelObject()
	return c==tc2
end

function s.thfilter1(c)
	return c:IsMonster() and c:ListsArchetype(SET_MEKLORD) and c:IsAbleToHand()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.thfilter1,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,#g,tp,LOCATION_GRAVE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_GRAVE,0,1,99,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end